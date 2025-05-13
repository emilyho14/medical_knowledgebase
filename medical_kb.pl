:- discontiguous patient/3.
:- discontiguous lab_test/3.
:- dynamic patient/3.
:- dynamic lab_test/3.

% -------------------
% Normal Laboratory Test Ranges
% -------------------
% Format: normal_range(Test, Min, Max, AgeGroup, Gender, Unit).
% -------------------

normal_range(ag_ratio, 1.0, 2.5, adult, both, 'ratio').

normal_range(alanine_aminotransferase, 8, 78, infant, both, 'U/L').
normal_range(alanine_aminotransferase, 8, 36, adult, both, 'U/L').

normal_range(albumin, 2.0, 4.0, infant, both, 'g/dL').
normal_range(albumin, 3.5, 5.5, adult, both, 'g/dL').

normal_range(alkaline_phosphatase, 60, 130, infant, both, 'U/L').
normal_range(alkaline_phosphatase, 85, 400, toddler, both, 'U/L').
normal_range(alkaline_phosphatase, 85, 400, child, both, 'U/L').
normal_range(alkaline_phosphatase, 85, 400, teen, both, 'U/L').
normal_range(alkaline_phosphatase, 30, 115, adult, both, 'U/L').

normal_range(ammonia, 90, 150, infant, both, 'mcg/dL').
normal_range(ammonia, 40, 120, toddler, both, 'mcg/dL').
normal_range(ammonia, 40, 120, child, both, 'mcg/dL').
normal_range(ammonia, 40, 120, teen, both, 'mcg/dL').
normal_range(ammonia, 18, 54, adult, both, 'mcg/dL').

normal_range(aspartate_aminotransferase, 18, 74, infant, both, 'U/L').
normal_range(aspartate_aminotransferase, 15, 46, toddler, both, 'U/L').
normal_range(aspartate_aminotransferase, 15, 46, child, both, 'U/L').
normal_range(aspartate_aminotransferase, 15, 46, teen, both, 'U/L').
normal_range(aspartate_aminotransferase, 5, 35, adult, both, 'U/L').

normal_range(bicarbonate, 22, 29, adult, both, 'mEq/L').

normal_range(bilirubin_direct, 0, 1.5, infant, both, 'mg/dL').
normal_range(bilirubin_direct, 0, 0.5, adult, both, 'mg/dL').

normal_range(bilirubin_total, 2.0, 10.0, infant, both, 'mg/dL').
normal_range(bilirubin_total, 0, 1.5, adult, both, 'mg/dL').

normal_range(blood_pressure_diastolic, 60, 80, both, both, 'mmHg').
normal_range(blood_pressure_systolic, 90, 120, both, both, 'mmHg').

normal_range(bun, 7, 20, adult, both, 'mg/dL').

normal_range(calcium, 7.0, 12.0, infant, both, 'mg/dL').
normal_range(calcium, 8.8, 11.2, toddler, both, 'mg/dL').
normal_range(calcium, 8.8, 11.2, child, both, 'mg/dL').
normal_range(calcium, 8.8, 11.2, teen, both, 'mg/dL').
normal_range(calcium, 9.0, 11.0, adult, both, 'mg/dL').

normal_range(ceruloplasmin, 25.0, 43.0, adult, both, 'mg/dL').

normal_range(chloride, 96, 106, adult, both, 'mEq/L').

normal_range(cholesterol, 45, 170, infant, both, 'mg/dL').
normal_range(cholesterol, 65, 175, toddler, both, 'mg/dL').
normal_range(cholesterol, 65, 175, child, both, 'mg/dL').
normal_range(cholesterol, 65, 175, teen, both, 'mg/dL').
normal_range(cholesterol, 120, 230, adult, both, 'mg/dL').

normal_range(copper, 100, 200, adult, both, 'ug/dL').

normal_range(creatinine, 0, 0.6, infant, both, 'mg/dL').
normal_range(creatinine, 0.5, 1.5, adult, both, 'mg/dL').

normal_range(egfr, 60, 120, adult, both, 'mL/min/1.73m²').

normal_range(fasting_glucose, 30, 90, infant, both, 'mg/dL').
normal_range(fasting_glucose, 60, 105, toddler, both, 'mg/dL').
normal_range(fasting_glucose, 60, 105, child, both, 'mg/dL').
normal_range(fasting_glucose, 60, 105, teen, both, 'mg/dL').
normal_range(fasting_glucose, 70, 110, adult, both, 'mg/dL').

normal_range(ferritin, 27, 307, adult, female, 'ng/mL').
normal_range(ferritin, 24, 336, adult, male, 'ng/mL').

normal_range(glucose, 30, 90, infant, both, 'mg/dL').
normal_range(glucose, 60, 105, toddler, both, 'mg/dL').
normal_range(glucose, 60, 105, child, both, 'mg/dL').
normal_range(glucose, 60, 105, teen, both, 'mg/dL').
normal_range(glucose, 70, 110, adult, both, 'mg/dL').

normal_range(hdl_cholesterol, 40, 100, adult, male, 'mg/dL').
normal_range(hdl_cholesterol, 50, 100, adult, female, 'mg/dL').

normal_range(hemoglobin, 13.5, 20.0, infant, both, 'g/dL').
normal_range(hemoglobin, 10.0, 14.0, child, both, 'g/dL').
normal_range(hemoglobin, 11.5, 15.5, teen, both, 'g/dL').
normal_range(hemoglobin, 13.5, 17.5, adult, male, 'g/dL').
normal_range(hemoglobin, 12.0, 15.5, adult, female, 'g/dL').

normal_range(hemoglobin_a1c, 4.0, 5.6, adult, both, '%').

normal_range(iron, 110, 270, infant, both, 'mcg/dL').
normal_range(iron, 60, 120, toddler, both, 'mcg/dL').
normal_range(iron, 55, 120, child, both, 'mcg/dL').
normal_range(iron, 55, 120, teen, both, 'mcg/dL').
normal_range(iron, 70, 180, adult, both, 'mcg/dL').

normal_range(inorganic_phosphorous, 3, 4.5, adult, both, 'mg/dL').

normal_range(ionized_calcium, 1.12, 1.23, adult, both, 'mmol/L').

normal_range(lactic_acid, 2, 20, both, both, 'mg/dL').
normal_range(ldl_cholesterol, 0, 100, adult, both, 'mg/dL').
normal_range(lipase, 20, 140, child, both, 'U/L').
normal_range(lipase, 0, 190, adult, both, 'U/L').

normal_range(ketones_urine, 0, 0, adult, both, 'mg/dL').

normal_range(magnesium, 1.5, 2.5, both, both, 'mEq/L').

normal_range(phosphate, 2.5, 4.5, both, both, 'mg/dL').

normal_range(phosphorus, 4.2, 9.0, infant, both, 'mg/dL').
normal_range(phosphorus, 3.8, 6.7, toddler, both, 'mg/dL').
normal_range(phosphorus, 3.8, 6.7, child, both, 'mg/dL').
normal_range(phosphorus, 3.8, 6.7, teen, both, 'mg/dL').
normal_range(phosphorus, 2.5, 5.0, adult, both, 'mg/dL').

normal_range(potassium, 4.5, 7.2, infant, both, 'mEq/L').
normal_range(potassium, 3.5, 5.0, toddler, both, 'mEq/L').
normal_range(potassium, 3.5, 5.0, child, both, 'mEq/L').
normal_range(potassium, 3.5, 5.0, teen, both, 'mEq/L').
normal_range(potassium, 3.5, 5.0, adult, both, 'mEq/L').

normal_range(protein_urine, 0, 0, adult, both, 'mg/dL').

normal_range(pyruvate, 0.08, 0.16, both, both, 'mmol/L').

normal_range(sodium, 136, 145, both, both, 'mEq/L').

normal_range(thyroid_stimulating_hormone, 0.7, 6.4, child, both, 'mIU/L').
normal_range(thyroid_stimulating_hormone, 0.4, 4.0, adult, both, 'mIU/L').

normal_range(total_calcium, 2.0, 2.6, both, both, 'mEq/L').

normal_range(total_iron_binding_capacity, 250, 310, both, both, 'ug/dL').

normal_range(total_protein, 6.0, 8.3, adult, both, 'g/dL').

normal_range(total_serum_iron, 50, 150, both, both, 'ug/dL').

normal_range(transferrin, 200, 400, both, both, 'mg/dL').

normal_range(triglycerides, 0, 171, infant, both, 'mg/dL').
normal_range(triglycerides, 20, 130, child, both, 'mg/dL').
normal_range(triglycerides, 20, 130, teen, both, 'mg/dL').
normal_range(triglycerides, 40, 160, adult, male, 'mg/dL').
normal_range(triglycerides, 35, 135, adult, female, 'mg/dL').

normal_range(urea, 1.2, 3.0, both, both, 'mmol/L').

normal_range(uric_acid, 0.18, 0.48, both, both, 'mmol/L').

normal_range(urine_ph, 4.5, 8.0, adult, both, 'none').

normal_range(urine_specific_gravity, 1.005, 1.030, adult, both, 'none').

normal_range(urobilinogen_urine, 0.1, 1.0, adult, both, 'mg/dL').

normal_range(white_blood_cell_count, 5.0, 17.5, child, both, '10^9/L').
normal_range(white_blood_cell_count, 4.5, 13.5, teen, both, '10^9/L').
normal_range(white_blood_cell_count, 4.5, 11.0, adult, both, '10^9/L').

normal_range(zinc, 75, 140, both, both, 'ug/dL').

% -------------------
% Age Group Classification
% -------------------
age_group(Age, infant) :- Age > 0, Age =< 1.
age_group(Age, toddler) :- Age > 1, Age =< 4.
age_group(Age, child) :- Age > 4, Age < 13.
age_group(Age, teen) :- Age >= 13, Age < 18.
age_group(Age, adult) :- Age >= 18.

% -------------------
% Range Lookup and Evaluation
% -------------------
get_range_status(TestRaw, Person, Value, Status) :-
    normalize_test_name(TestRaw, Test),
    patient(Person, Age, Gender),
    age_group(Age, AgeGroup),
    (   find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, _Unit)
    ->  (Value < Min -> Status = toolow
        ; Value > Max -> Status = toohigh
        ; Status = normal)
    ;   Status = unknown
    ).

find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, Unit) :-
    (   normal_range(Test, Min, Max, AgeGroup, Gender, Unit)
    ;   normal_range(Test, Min, Max, AgeGroup, both, Unit)
    ;   normal_range(Test, Min, Max, _, Gender, Unit)
    ;   normal_range(Test, Min, Max, _, both, Unit)
    ),
    !.

normalize_test_name(Raw, Cleaned) :-
    (   atom(Raw) -> AtomRaw = Raw ; atom_string(Raw, AtomRaw)
    ),
    downcase_atom(AtomRaw, Lower),
    atom_chars(Lower, Chars),
    maplist(replace_non_alnum, Chars, NormalizedChars),
    atom_chars(Cleaned, NormalizedChars).

replace_non_alnum(Char, '_') :- \+ char_type(Char, alnum), !.
replace_non_alnum(Char, Char).

% -------------------
% Diagnoses using get_range_status/4
% -------------------
diagnosis(Person, acute_liver_failure) :-
    lab_test(Person, alt, ALT), get_range_status(alt, Person, ALT, toohigh),
    lab_test(Person, ast, AST), get_range_status(ast, Person, AST, toohigh),
    lab_test(Person, bilirubin_total, Bili), get_range_status(bilirubin_total, Person, Bili, toohigh).

diagnosis(Person, anemia) :-
    lab_test(Person, hemoglobin, Hgb), get_range_status(hemoglobin, Person, Hgb, toolow).

diagnosis(Person, chronic_kidney_disease) :-
    lab_test(Person, creatinine, Creat), get_range_status(creatinine, Person, Creat, toohigh),
    lab_test(Person, gfr, GFR), get_range_status(gfr, Person, GFR, toolow).

diagnosis(Person, dehydration) :-
    lab_test(Person, urine_specific_gravity, SG), get_range_status(urine_specific_gravity, Person, SG, toohigh),
    lab_test(Person, sodium, Na), get_range_status(sodium, Person, Na, toohigh).

diagnosis(Person, diabetes) :-
    lab_test(Person, fasting_glucose, Glucose),
    get_range_status(fasting_glucose, Person, Glucose, toohigh).

diagnosis(Person, hyperkalemia) :-
    lab_test(Person, potassium, K), get_range_status(potassium, Person, K, toohigh).

diagnosis(Person, hyperlipidemia) :-
    lab_test(Person, ldl_cholesterol, LDL), get_range_status(ldl_cholesterol, Person, LDL, toohigh).

diagnosis(Person, hypernatremia) :-
    lab_test(Person, sodium, Na), get_range_status(sodium, Person, Na, toohigh).

diagnosis(Person, hypocalcemia) :-
    lab_test(Person, total_calcium, Ca), get_range_status(total_calcium, Person, Ca, toolow).

diagnosis(Person, hyponatremia) :-
    lab_test(Person, sodium, Na), get_range_status(sodium, Person, Na, toolow).

diagnosis(Person, iron_deficiency) :-
    lab_test(Person, ferritin, Ferritin), get_range_status(ferritin, Person, Ferritin, toolow).

diagnosis(Person, kidney_disease) :-
    lab_test(Person, creatinine, Creat), get_range_status(creatinine, Person, Creat, toohigh).

diagnosis(Person, liver_disease) :-
    lab_test(Person, alt, ALT), get_range_status(alt, Person, ALT, toohigh),
    lab_test(Person, ast, AST), get_range_status(ast, Person, AST, toohigh).

diagnosis(Person, liver_dysfunction) :-
    lab_test(Person, albumin, Alb), get_range_status(albumin, Person, Alb, toolow),
    lab_test(Person, alanine_aminotransferase, ALT), get_range_status(alanine_aminotransferase, Person, ALT, toohigh).

diagnosis(Person, metabolic_acidosis) :-
    lab_test(Person, bicarbonate, Bicarb), get_range_status(bicarbonate, Person, Bicarb, toolow).

diagnosis(Person, metabolic_syndrome) :-
    lab_test(Person, glucose, Glu), get_range_status(glucose, Person, Glu, toohigh),
    lab_test(Person, triglycerides, TG), get_range_status(triglycerides, Person, TG, toohigh),
    lab_test(Person, hdl_cholesterol, HDL), get_range_status(hdl_cholesterol, Person, HDL, toolow).

diagnosis(Person, prediabetes) :-
    lab_test(Person, fasting_glucose, Glucose),
    get_range_status(fasting_glucose, Person, Glucose, normal),
    patient(Person, Age, Gender),
    age_group(Age, AgeGroup),
    find_normal_range_with_fallback(fasting_glucose, AgeGroup, Gender, _, Max, _),
    Threshold is Max - 5,
    Glucose >= Threshold.
    
% -------------------
% Find All Diagnoses
% -------------------
all_diagnoses(Person, Diagnoses) :-
    setof(D, diagnosis(Person, D), Diagnoses), !.
all_diagnoses(_, []).

% -------------------
% Explanation Generator
% -------------------
diagnosis_explanation(Person, Diagnosis, Explanation) :-
    diagnosis(Person, Diagnosis),
    format(atom(Explanation), '~w may have ~w based on current lab values.', [Person, Diagnosis]).

all_explanations(Person, Explanations) :-
    findall(Explanation, diagnosis_explanation(Person, _, Explanation), Explanations).

% -------------------
% Sample Data
% -------------------
patient(john, 35, male).
patient(sarah, 10, female).
patient(baby_jane, 1, female).

lab_test(john, fasting_glucose, 130).
lab_test(john, hemoglobin, 13).
lab_test(john, potassium, 6.0).

lab_test(sarah, fasting_glucose, 110).
lab_test(sarah, hemoglobin, 11).
lab_test(sarah, sodium, 130).

lab_test(baby_jane, bilirubin_total, 8.0).
lab_test(baby_jane, potassium, 5.0).
lab_test(baby_jane, fasting_glucose, 200).
lab_test(baby_jane, alt, 45).
lab_test(baby_jane, ast, 40).

patient(dummy, 35, male).
lab_test(dummy, fasting_glucose, 130).
lab_test(dummy, hemoglobin, 13).
lab_test(dummy, potassium, 6.0).
