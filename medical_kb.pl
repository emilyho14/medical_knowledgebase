% -------------------
% Normal Laboratory Test Ranges (Expanded)
% -------------------
% Format: normal_range(Test, Min, Max, AgeGroup, Gender, Unit).
% -------------------

normal_range('Alanine_Aminotransferase', 8, 78, 'newborn', 'both', 'U/L').
normal_range('Alanine_Aminotransferase', 8, 36, 'adult', 'both', 'U/L').

normal_range('Albumin', 2.0, 4.0, 'newborn', 'both', 'g/dL').
normal_range('Albumin', 3.5, 5.5, 'adult', 'both', 'g/dL').

normal_range('Alkaline_Phosphatase', 60, 130, 'newborn', 'both', 'U/L').
normal_range('Alkaline_Phosphatase', 85, 400, 'child', 'both', 'U/L').
normal_range('Alkaline_Phosphatase', 30, 115, 'adult', 'both', 'U/L').

normal_range('Ammonia', 90, 150, 'newborn', 'both', 'mcg/dL').
normal_range('Ammonia', 40, 120, 'child', 'both', 'mcg/dL').
normal_range('Ammonia', 18, 54, 'adult', 'both', 'mcg/dL').

normal_range('Aspartate_Aminotransferase', 18, 74, 'newborn', 'both', 'U/L').
normal_range('Aspartate_Aminotransferase', 15, 46, 'child', 'both', 'U/L').
normal_range('Aspartate_Aminotransferase', 5, 35, 'adult', 'both', 'U/L').

normal_range('Bilirubin_Direct', 0, 1.5, 'newborn', 'both', 'mg/dL').
normal_range('Bilirubin_Direct', 0, 0.5, 'adult', 'both', 'mg/dL').

normal_range('Bilirubin_Total', 2.0, 10.0, 'newborn', 'both', 'mg/dL').
normal_range('Bilirubin_Total', 0, 1.5, 'adult', 'both', 'mg/dL').

normal_range('Blood_Pressure_Diastolic', 60, 80, 'both', 'both', 'mmHg').
normal_range('Blood_Pressure_Systolic', 90, 120, 'both', 'both', 'mmHg').

normal_range('Calcium', 7.0, 12.0, 'newborn', 'both', 'mg/dL').
normal_range('Calcium', 8.8, 11.2, 'child', 'both', 'mg/dL').
normal_range('Calcium', 9.0, 11.0, 'adult', 'both', 'mg/dL').

normal_range('Cholesterol', 45, 170, 'newborn', 'both', 'mg/dL').
normal_range('Cholesterol', 65, 175, 'child', 'both', 'mg/dL').
normal_range('Cholesterol', 120, 230, 'adult', 'both', 'mg/dL').

normal_range('Creatinine', 0, 0.6, 'newborn', 'both', 'mg/dL').
normal_range('Creatinine', 0.5, 1.5, 'adult', 'both', 'mg/dL').

normal_range('Glucose', 30, 90, 'newborn', 'both', 'mg/dL').
normal_range('Glucose', 60, 105, 'child', 'both', 'mg/dL').
normal_range('Glucose', 70, 110, 'adult', 'both', 'mg/dL').

normal_range('Iron', 110, 270, 'newborn', 'both', 'mcg/dL').
normal_range('Iron', 55, 120, 'child', 'both', 'mcg/dL').
normal_range('Iron', 70, 180, 'adult', 'both', 'mcg/dL').

normal_range('Lactic_Acid', 2, 20, 'both', 'both', 'mg/dL').
normal_range('Lipase', 20, 140, 'child', 'both', 'U/L').
normal_range('Lipase', 0, 190, 'adult', 'both', 'U/L').

normal_range('Magnesium', 1.5, 2.5, 'both', 'both', 'mEq/L').

normal_range('Phosphorus', 4.2, 9.0, 'newborn', 'both', 'mg/dL').
normal_range('Phosphorus', 3.8, 6.7, 'child', 'both', 'mg/dL').
normal_range('Phosphorus', 2.5, 5.0, 'adult', 'both', 'mg/dL').

normal_range('Potassium', 4.5, 7.2, 'newborn', 'both', 'mEq/L').
normal_range('Potassium', 3.5, 5.0, 'adult', 'both', 'mEq/L').

normal_range('Sodium', 136, 145, 'both', 'both', 'mEq/L').

normal_range('Triglycerides', 0, 171, 'infant', 'both', 'mg/dL').
normal_range('Triglycerides', 20, 130, 'child', 'both', 'mg/dL').
normal_range('Triglycerides', 30, 200, 'adult', 'both', 'mg/dL').

% -------------------
% Age Group Classification
% -------------------
age_group(Age, 'newborn') :- Age =< 1.
age_group(Age, 'child') :- Age > 1, Age < 18.
age_group(Age, 'adult') :- Age >= 18.

% -------------------
% Abnormal Value Detection
% -------------------
abnormal(Person, Test, Value, Status, Unit) :-
    patient(Person, Age, _),
    age_group(Age, AgeGroup),
    normal_range(Test, Min, Max, AgeGroup, _, Unit),
    (Value < Min -> Status = low;
     Value > Max -> Status = high;
     Status = normal).

% -------------------
% Diagnoses
% -------------------
diagnosis(Person, diabetes) :-
    lab_test(Person, fasting_glucose, Glucose),
    Glucose >= 126.

diagnosis(Person, prediabetes) :-
    lab_test(Person, fasting_glucose, Glucose),
    Glucose >= 100, Glucose =< 125.

diagnosis(Person, anemia) :-
    patient(Person, _, 'male'),
    lab_test(Person, hemoglobin, Hgb),
    Hgb < 14.

diagnosis(Person, anemia) :-
    patient(Person, _, 'female'),
    lab_test(Person, hemoglobin, Hgb),
    Hgb < 12.

diagnosis(Person, hyperlipidemia) :-
    lab_test(Person, ldl_cholesterol, LDL),
    LDL > 100.

diagnosis(Person, kidney_disease) :-
    lab_test(Person, creatinine, Creat),
    Creat > 1.3.

diagnosis(Person, liver_disease) :-
    lab_test(Person, alt, ALT),
    lab_test(Person, ast, AST),
    ALT > 40, AST > 35.

diagnosis(Person, hyperkalemia) :-
    lab_test(Person, potassium, K),
    K > 5.5.

diagnosis(Person, hyponatremia) :-
    lab_test(Person, sodium, Na),
    Na < 135.

% -------------------
% Find All Diagnoses
% -------------------
all_diagnoses(Person, Diagnoses) :-
    findall(D, diagnosis(Person, D), Diagnoses).

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
patient(john, 35, 'male').
patient(sarah, 10, 'female').
patient(baby_jane, 1, 'female').

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

% -------------------
% USAGE INSTRUCTIONS (in SWI-Prolog terminal)
% -------------------
% 1. Load the file:
%    ?- [your_file_name].
% 
% 2. Find all diagnoses for a patient:
%    ?- all_diagnoses(john, D).
%    D = [diabetes, anemia, hyperkalemia].
%
% 3. Get explanations for those diagnoses:
%    ?- all_explanations(john, E).
%    E = ['john may have diabetes based on current lab values.',
%         'john may have anemia based on current lab values.',
%         'john may have hyperkalemia based on current lab values.'].
%
% 4. Show diagnosis explanations one by one:
%    ?- diagnosis_explanation(john, D, E).
%    D = diabetes, E = 'john may have diabetes based on current lab values.' ;
%    D = anemia, E = 'john may have anemia based on current lab values.' ;
%    ... etc.
%
% Press `;` to continue seeing next results.
