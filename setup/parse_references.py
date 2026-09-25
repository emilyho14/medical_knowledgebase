"""Extract reviewable laboratory-range candidates from reference PDFs.

This module deliberately does not decide which source is correct. It stores
the source page and evidence text for every candidate so that selection can be
reviewed and changed without re-parsing the PDFs.
"""

from __future__ import annotations

import argparse
import importlib
import importlib.util
import json
import re
import shutil
import statistics
import subprocess
from dataclasses import asdict, dataclass
from pathlib import Path
from typing import Iterable


LAB_RESULT_DIR = Path(__file__).resolve().parents[1] / "lab_result_references"
NUMBER = r"[+-]?(?:\d+(?:\.\d+)?|\.\d+)"
RANGE_RE = re.compile(
	rf"(?P<lower>{NUMBER})\s*(?P<separator>-|\u2013|\u2014|to)\s*"
	rf"(?P<upper>{NUMBER})(?:\s*(?P<unit>[A-Za-z\u00b5\u03bc/%][A-Za-z0-9\u00b5\u03bc/%^.*()_-]*))?",
	re.IGNORECASE,
)
AGE_RE = re.compile(r"\b(infant|neonate|newborn|toddler|child|pediatric|teen|adolescent|adult|elderly)\b", re.I)
SEX_RE = re.compile(r"\b(male|female|men|women|man|woman|both sexes)\b", re.I)


@dataclass(frozen=True)
class RangeCandidate:
	source_file: str
	page: int
	test_name: str
	lower: float
	upper: float
	unit: str | None
	age_group: str | None
	sex: str | None
	condition: str | None
	evidence: str
	extraction_method: str
	confidence: str


def extract_pages(pdf_path: Path) -> Iterable[tuple[int, str, str]]:
	"""Yield (page number, text, extraction method) for one PDF.

	pypdf is preferred because it preserves page boundaries. The pdftotext
	fallback is useful on machines where pypdf is not installed.
	"""
	pypdf = importlib.util.find_spec("pypdf")
	if pypdf is not None:
		pdf_reader = importlib.import_module("pypdf").PdfReader
		for page_number, page in enumerate(pdf_reader(str(pdf_path)).pages, 1):
			yield page_number, page.extract_text() or "", "pypdf"
		return

	if shutil.which("pdftotext") is None:
		raise RuntimeError(
			"Install pypdf (`python -m pip install pypdf`) or Poppler "
			"(`brew install poppler`) to extract PDF text."
		)

	result = subprocess.run(
		["pdftotext", "-layout", str(pdf_path), "-"],
		check=True,
		capture_output=True,
		text=True,
	)
	# This fallback cannot reliably recover page breaks, so retain the whole
	# document as page 1 and mark it as lower-confidence evidence.
	yield 1, result.stdout, "pdftotext"


def clean_test_name(raw: str) -> str:
	raw = re.sub(r"[^A-Za-z0-9]+", "_", raw.strip().lower()).strip("_")
	return raw


def looks_like_test_label(label: str, lower: float, upper: float) -> bool:
	"""Reject obvious metadata and contact-number false positives."""
	lowered = label.lower()
	rejected_terms = ("isbn", "published", "copyright", "phone", "fax", "address")
	if any(term in lowered for term in rejected_terms):
		return False
	if not re.search(r"[A-Za-z]", label) or len(label.split()) > 10:
		return False
	if len(label) > 70 or (upper - lower > 10000 and not re.search(r"[A-Za-z]{2,}", label)):
		return False
	return True


def infer_context(text: str) -> tuple[str | None, str | None, str | None]:
	age = AGE_RE.search(text)
	sex = SEX_RE.search(text)
	condition = None
	condition_terms = ("fasting", "nonfasting", "pregnan", "random", "postprandial", "24 hour")
	for term in condition_terms:
		if term in text.lower():
			condition = term
			break
	return (
		age.group(1).lower() if age else None,
		sex.group(1).lower() if sex else None,
		condition,
	)


def candidates_from_page(pdf_path: Path, page: int, text: str, method: str) -> list[RangeCandidate]:
	candidates: list[RangeCandidate] = []
	lines = [line.strip() for line in text.splitlines() if line.strip()]
	for index, line in enumerate(lines):
		match = RANGE_RE.search(line)
		if not match:
			continue

		# Most tables put the analyte in the same line or immediately above it.
		label = line[: match.start()].strip(" :.-")
		if not label and index:
			label = lines[index - 1].split(match.group(0))[0].strip(" :.-")
		lower = float(match.group("lower"))
		upper = float(match.group("upper"))
		if not label or label.isdigit() or upper < lower or not looks_like_test_label(label, lower, upper):
			continue

		context = " ".join(lines[max(0, index - 1) : min(len(lines), index + 2)])
		age_group, sex, condition = infer_context(context)
		candidates.append(
			RangeCandidate(
				source_file=pdf_path.name,
				page=page,
				test_name=clean_test_name(label),
				lower=lower,
				upper=upper,
				unit=match.group("unit"),
				age_group=age_group,
				sex=sex,
				condition=condition,
				evidence=context,
				extraction_method=method,
				confidence="review" if method == "pypdf" else "low",
			)
		)
	return candidates


def extract_directory(directory: Path) -> list[RangeCandidate]:
	candidates: list[RangeCandidate] = []
	for pdf_path in sorted(directory.glob("*.pdf")):
		for page, text, method in extract_pages(pdf_path):
			candidates.extend(candidates_from_page(pdf_path, page, text, method))
	return candidates


def write_jsonl(candidates: Iterable[RangeCandidate], output: Path) -> None:
	with output.open("w", encoding="utf-8") as stream:
		for candidate in candidates:
			stream.write(json.dumps(asdict(candidate), sort_keys=True) + "\n")


def select_best_fit(
	candidates: Iterable[RangeCandidate],
	*,
	test_name: str,
	age_group: str | None = None,
	sex: str | None = None,
	condition: str | None = None,
	source_priority: list[str] | None = None,
) -> RangeCandidate | None:
	"""Select one candidate using explicit criteria and source preference.

	This is intentionally not an average. Averaging ranges from different
	populations can create a range that no source actually supports.
	"""
	priority = {name: index for index, name in enumerate(source_priority or [])}
	matching = [candidate for candidate in candidates if candidate.test_name == test_name]

	def score(candidate: RangeCandidate) -> tuple[int, int, int, int]:
		population_match = int(age_group is not None and candidate.age_group == age_group)
		sex_match = int(sex is not None and candidate.sex in (sex, "both sexes"))
		condition_match = int(condition is not None and candidate.condition == condition)
		source_score = -priority.get(candidate.source_file, len(priority) + 1)
		return population_match, sex_match, condition_match, source_score

	return max(matching, key=score, default=None)


def aggregate_ranges(
	candidates: Iterable[RangeCandidate],
	*,
	test_name: str,
	unit: str,
	age_group: str | None = None,
	sex: str | None = None,
	condition: str | None = None,
	method: str = "median",
) -> dict[str, float | int | str] | None:
	"""Summarize comparable reviewed candidates.

	Aggregation is allowed only after the caller supplies the same unit and
	population filters. Median is the default because it is less sensitive to
	an outlying source; use mean only when that choice is justified.
	"""
	if method not in {"mean", "median"}:
		raise ValueError("method must be 'mean' or 'median'")

	matching = [
		candidate
		for candidate in candidates
		if candidate.test_name == test_name
		and candidate.unit == unit
		and (age_group is None or candidate.age_group == age_group)
		and (sex is None or candidate.sex in (sex, "both sexes"))
		and (condition is None or candidate.condition == condition)
	]
	if not matching:
		return None

	reducer = statistics.mean if method == "mean" else statistics.median
	return {
		"test_name": test_name,
		"unit": unit,
		"lower": reducer(candidate.lower for candidate in matching),
		"upper": reducer(candidate.upper for candidate in matching),
		"source_count": len(matching),
		"aggregation": method,
	}


def main() -> None:
	parser = argparse.ArgumentParser(description=__doc__)
	parser.add_argument("--input", type=Path, default=LAB_RESULT_DIR)
	parser.add_argument("--output", type=Path, default=Path("setup/reference_candidates.jsonl"))
	args = parser.parse_args()

	candidates = extract_directory(args.input)
	args.output.parent.mkdir(parents=True, exist_ok=True)
	write_jsonl(candidates, args.output)
	print(f"Wrote {len(candidates)} candidates to {args.output}")


if __name__ == "__main__":
	main()

