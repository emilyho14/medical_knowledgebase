% Load the medical knowledge base
:- consult('medical_kb.pl').

% Start the server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]).

% Abnormal test logic
handle_abnormal(Request) :-
    http_read_json_dict(Request, Dict),
    normalize_test_name(Dict.test, Test),
    Age = Dict.age,
    Gender = Dict.gender,
    age_group(Age, AgeGroup),
    (   find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, Unit)
    ->  (Dict.value < Min -> Status = low
        ; Dict.value > Max -> Status = high
        ; Status = normal),
        reply_json_dict(_{status: Status, unit: Unit})
    ;   reply_json_dict(_{error: "Test not found"}, [status(404)])
    ).

% Get all unique tests from normal_range facts
handle_get_tests(_Request) :-
    setof(Test, Min^Max^Age^Gender^Unit^normal_range(Test, Min, Max, Age, Gender, Unit), RawTests),
    maplist(capitalize_atom_words, RawTests, CapitalizedTests),
    reply_json_dict(_{tests: CapitalizedTests}).

% Capitalize each word separated by underscores
capitalize_atom_words(Atom, Capitalized) :-
    atomic_list_concat(Parts, '_', Atom),
    maplist(cap_word, Parts, CapitalizedParts),
    atomic_list_concat(CapitalizedParts, ' ', Capitalized).

cap_word(Part, Capitalized) :-
    atom_chars(Part, [H|T]),
    upcase_atom(H, UH),
    atom_chars(Capitalized, [UH|T]).

% Abnormal predicate for CLI use
abnormal(_, TestRaw, Value, Status, Unit) :-
    normalize_test_name(TestRaw, Test),
    patient(_, Age, Gender),
    age_group(Age, AgeGroup),
    find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, Unit),
    (Value < Min -> Status = low ;
     Value > Max -> Status = high ;
     Status = normal).

with_patient_and_tests(Patient, Age, Gender, Tests, Goal) :-
    % Setup
    asserta(patient(Patient, Age, Gender)),
    maplist(asserta, Tests),
    % Run your goal
    (   call(Goal)
    ->  Result = true
    ;   Result = fail),
    % Cleanup
    retractall(patient(Patient, _, _)),
    maplist(retract, Tests),
    Result == true.


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

test(abnormal_when_hemoglobin_normal_for_child) :-
    with_patient_and_tests(dummy, 10, male,
        [ lab_test(dummy, hemoglobin, 11) ],
        abnormal(dummy, hemoglobin, 11, normal, 'g/dL')).

test(abnormal_when_sodium_low_for_child) :- abnormal(dummy, sodium, 130, low, 'mEq/L').

test(abnormal_when_bilirubin_normal_for_infant) :-
    with_patient_and_tests(dummy, 0.5, female,
        [ lab_test(dummy, bilirubin_total, 8.0) ],
        abnormal(dummy, bilirubin_total, 8.0, normal, 'mg/dL')).


test(abnormal_when_calcium_low_for_adult) :- abnormal(dummy, calcium, 8.0, low, 'mg/dL').

test(abnormal_when_albumin_high_for_infant) :-
    with_patient_and_tests(dummy, 0.4, female,
        [ lab_test(dummy, albumin, 5.0) ],
        abnormal(dummy, albumin, 5.0, high, 'g/dL')).


test(abnormal_when_iron_normal_for_child) :- abnormal(dummy, iron, 100, normal, 'mcg/dL').

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
          writeln(D),  % DEBUG LINE
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