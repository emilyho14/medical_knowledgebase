:- consult('medical_kb.pl').


% -------------------
% Expanded Diagnosis Tests
% -------------------
:- begin_tests(medical_kb_tests).

% Age group logic tests
test(age_group_when_age_is_1_is_infant) :- age_group(1, infant).
test(age_group_when_age_is_3_is_toddler) :- age_group(3, toddler).
test(age_group_when_age_is_7_is_child) :- age_group(7, child).
test(age_group_when_age_is_15_is_teen) :- age_group(15, teen).
test(age_group_when_age_is_20_is_adult) :- age_group(20, adult).
test(age_group_when_age_is_0_5_is_infant) :- age_group(0.5, infant).
test(age_group_when_age_is_4_is_toddler) :- age_group(4, toddler).
test(age_group_when_age_is_12_is_child) :- age_group(12, child).
test(age_group_when_age_is_17_is_teen) :- age_group(17, teen).
test(age_group_when_age_is_30_is_adult) :- age_group(30, adult).


% Abnormality logic tests
test(abnormal_when_potassium_high_in_adult) :- abnormal(dummy, 'Potassium', 6.0, high, 'mEq/L').

test(abnormal_accepts_alt_alias) :-
    with_patient_and_tests(dummy, 35, male,
        [ lab_test(dummy, alt, 40) ],
        abnormal(dummy, alt, 40, high, 'U/L')).

test(abnormal_does_not_use_another_age_group_range, [fail]) :-
    with_patient_and_tests(dummy, 10, female,
        [ lab_test(dummy, ferritin, 10) ],
        abnormal(dummy, ferritin, 10, low, 'ng/mL')).

test(abnormal_when_hemoglobin_normal_for_child) :-
    with_patient_and_tests(dummy, 10, male,
        [ lab_test(dummy, hemoglobin, 11) ],
        abnormal(dummy, hemoglobin, 11, normal, 'g/dL')).

test(abnormal_when_sodium_low_for_child) :-
    with_patient_and_tests(dummy, 10, male,
        [ lab_test(dummy, sodium, 130) ],
        abnormal(dummy, sodium, 130, low, 'mEq/L')).

test(abnormal_when_bilirubin_normal_for_infant) :-
    with_patient_and_tests(dummy, 0.5, female,
        [ lab_test(dummy, bilirubin_total, 8.0) ],
        abnormal(dummy, bilirubin_total, 8.0, normal, 'mg/dL')).


test(abnormal_when_calcium_low_for_adult) :-
    with_patient_and_tests(dummy, 35, male,
        [ lab_test(dummy, calcium, 8.0) ],
        abnormal(dummy, calcium, 8.0, low, 'mg/dL')).

test(abnormal_when_albumin_high_for_infant) :-
    with_patient_and_tests(dummy, 0.4, female,
        [ lab_test(dummy, albumin, 5.0) ],
        abnormal(dummy, albumin, 5.0, high, 'g/dL')).


test(abnormal_when_iron_normal_for_child) :-
    with_patient_and_tests(dummy, 10, male,
        [ lab_test(dummy, iron, 100) ],
        abnormal(dummy, iron, 100, normal, 'mcg/dL')).

test(abnormal_when_hemoglobin_low_for_female) :-
    with_patient_and_tests(dummy, 40, female,
        [ lab_test(dummy, hemoglobin, 11.0) ],
        abnormal(dummy, hemoglobin, 11.0, low, 'g/dL')).


test(abnormal_when_hdl_low_for_female) :-
    with_patient_and_tests(dummy, 35, female,
        [ lab_test(dummy, hdl_cholesterol, 45) ],
        abnormal(dummy, hdl_cholesterol, 45, low, 'mg/dL')).

% Diagnosis logic tests
test(diagnoses_include_diabetes_anemia_hyperkalemia_for_adult_male) :-
    with_patient_and_tests(dummy, 35, male,
        [ lab_test(dummy, fasting_glucose, 130),
          lab_test(dummy, hemoglobin, 13),
          lab_test(dummy, potassium, 6.0)
        ],
        ( all_diagnoses(dummy, D),
          subset([diabetes, anemia, hyperkalemia], D)
        )).


test(diagnosis_explanation_correct_for_diabetes) :-
    with_patient_and_tests(dummy, 35, male,
        [ lab_test(dummy, fasting_glucose, 130) ],
        ( diagnosis_explanation(dummy, diabetes, E),
          E = 'dummy may have diabetes based on current lab values.'
        )).

test(explanations_contain_anemia_for_low_hemoglobin) :-
    with_patient_and_tests(dummy, 35, male,
        [ lab_test(dummy, hemoglobin, 13) ],
        ( all_explanations(dummy, Es),
          member('dummy may have anemia based on current lab values.', Es)
        )).

test(diagnosis_metabolic_syndrome_detected) :-
    with_patient_and_tests(dummy, 45, male,
        [ lab_test(dummy, glucose, 111),
          lab_test(dummy, triglycerides, 161),
          lab_test(dummy, hdl_cholesterol, 35)
        ],
        diagnosis(dummy, metabolic_syndrome)
    ).

test(diagnosis_hypernatremia_detected) :-
    with_patient_and_tests(dummy, 60, male,
        [ lab_test(dummy, sodium, 150)
        ],
        diagnosis(dummy, hypernatremia)
    ).

test(diagnosis_hypocalcemia_detected) :-
    with_patient_and_tests(dummy, 28, female,
        [ lab_test(dummy, total_calcium, 1.9)
        ],
        diagnosis(dummy, hypocalcemia)
    ).

test(diagnosis_dehydration_detected) :-
    with_patient_and_tests(dummy, 50, female,
        [ lab_test(dummy, urine_specific_gravity, 1.035),
          lab_test(dummy, sodium, 146)
        ],
        diagnosis(dummy, dehydration)
    ).

test(diagnosis_liver_dysfunction_detected) :-
    with_patient_and_tests(dummy, 50, female,
        [ lab_test(dummy, albumin, 2.5),
          lab_test(dummy, alanine_aminotransferase, 50)
        ],
        diagnosis(dummy, liver_dysfunction)
    ).

% Negative test
test(diagnosis_should_fail_for_pregnancy_in_male, [fail]) :- diagnosis(dummy, pregnancy).

:- end_tests(medical_kb_tests).