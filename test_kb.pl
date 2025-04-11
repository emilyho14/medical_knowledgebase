:- begin_tests(medical_kb_tests).

% --- Age Group Tests ---
test(age_group_infant) :- age_group(1, infant).
test(age_group_toddler) :- age_group(3, toddler).
test(age_group_child) :- age_group(7, child).
test(age_group_teen) :- age_group(15, teen).
test(age_group_adult) :- age_group(20, adult).

% --- Abnormal Value Detection ---
test(abnormal_high_potassium_john) :-
    abnormal(john, 'Potassium', 6.0, high, 'mEq/L').

test(abnormal_normal_hemoglobin_sarah) :-
    abnormal(sarah, hemoglobin, 11, normal, 'g/dL').

test(abnormal_low_sodium_sarah) :-
    abnormal(sarah, sodium, 130, low, 'mEq/L').

test(abnormal_normal_bilirubin_baby_jane) :-
    abnormal(baby_jane, 'Bilirubin_Total', 8.0, normal, 'mg/dL').

% --- Diagnoses: John ---
test(all_diagnoses_john) :-
    all_diagnoses(john, D),
    sort(D, Sorted),
    sort([diabetes, anemia, hyperkalemia], Expected),
    Sorted = Expected.

test(diagnosis_explanation_john_diabetes) :-
    diagnosis_explanation(john, diabetes, E),
    E = 'john may have diabetes based on current lab values.'.

test(all_explanations_john_contains_anemia, [true(ContainsAnemia)]) :-
    all_explanations(john, Es),
    member('john may have anemia based on current lab values.', Es),
    ContainsAnemia = true.

% --- Diagnoses: Sarah ---
test(all_diagnoses_sarah) :-
    all_diagnoses(sarah, D),
    sort(D, Sorted),
    sort([prediabetes, anemia, hyponatremia], Sorted).

test(diagnosis_explanation_sarah_hyponatremia) :-
    diagnosis_explanation(sarah, hyponatremia, E),
    E = 'sarah may have hyponatremia based on current lab values.'.

% --- Diagnoses: Baby Jane ---
test(all_diagnoses_baby_jane) :-
    all_diagnoses(baby_jane, D),
    sort(D, Sorted),
    sort([diabetes, liver_disease], Sorted).

test(diagnosis_explanation_baby_jane_diabetes) :-
    diagnosis_explanation(baby_jane, diabetes, E),
    E = 'baby_jane may have diabetes based on current lab values.'.

% --- Negative Test Case ---
test(john_is_not_pregnant, [fail]) :-
    diagnosis(john, pregnancy).

:- end_tests(medical_kb_tests).