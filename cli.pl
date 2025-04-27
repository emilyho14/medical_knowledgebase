:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/http_cors)).
:- use_module(library(http/http_files)).

% Serve static HTML from current directory
:- http_handler(root(.), http_reply_file('index.html', []), []).
:- http_handler(root(.), serve_files_in_directory('.'), [prefix]).

:- consult(medical_kb).

:- set_setting(http:cors, [*]).

:- http_handler(root(tests), get_tests, []).
:- http_handler(root(abnormal), check_abnormal, [method(post)]).

% ----------- Handlers -----------

get_tests(_Request) :-
    setof(Test, Age^Min^Max^Gender^Unit^normal_range(Test, Min, Max, Age, Gender, Unit), Tests),
    maplist(format_label, Tests, Labels),
    reply_json_dict(_{tests: Labels}).

format_label(TestAtom, Label) :-
    atom_chars(TestAtom, Chars),
    maplist(replace_underscore, Chars, NewChars),
    atom_chars(Label, NewChars).

replace_underscore('_', ' ') :- !.
replace_underscore(C, C).

check_abnormal(Request) :-
    http_read_json_dict(Request, Dict),
    % Build a temporary patient fact dynamically
    Age = Dict.age,
    Gender = Dict.gender,
    Test = Dict.test,
    Value = Dict.value,
    gensym(temp_person_, TempPerson),
    assertz(patient(TempPerson, Age, Gender)),
    assertz(lab_test(TempPerson, Test, Value)),
    (   abnormal(TempPerson, Test, Value, Status, Unit)
    ->  Result = _{status: Status, unit: Unit}
    ;   Result = _{status: "unknown", unit: "?"}
    ),
    % Cleanup
    retractall(patient(TempPerson, _, _)),
    retractall(lab_test(TempPerson, _, _)),
    reply_json_dict(Result).
