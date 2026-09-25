:- module(lab_server, [start_server/1, handle_abnormal/1, handle_get_tests/1]).

:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_files)).
:- use_module(library(http/http_parameters)).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Load the medical knowledge base
:- consult('medical_kb.pl').

% HTTP handlers
:- http_handler(root(.), http_reply_file('index.html', []), []).
:- http_handler(root(.), serve_files_in_directory('.'), [prefix]).
:- http_handler(root(abnormal), handle_abnormal, [method(post)]).
:- http_handler(root(tests), handle_get_tests, [method(get)]).

% Start the server
start_server(Port) :-
    http_server(http_dispatch, [port(Port)]),
    thread_get_message(_).

% Handle abnormal test detection
handle_abnormal(Request) :-
    http_read_json_dict(Request, Dict),
    normalize_test_name(Dict.test, Test),
    normalize_gender(Dict.gender, Gender),
    gensym(temp_person_, Person),
    with_patient_and_tests(
        Person, Dict.age, Gender, [lab_test(Person, Test, Dict.value)],
        (abnormal(Person, Test, Dict.value, Status, Unit)
        -> reply_json_dict(_{status: Status, unit: Unit})
        ;  reply_json_dict(_{status: unknown, unit: "?"}))
    ).

% Get list of available tests
handle_get_tests(_Request) :-
    setof(Test, Min^Max^Age^Gender^Unit^normal_range(Test, Min, Max, Age, Gender, Unit), RawTests),
    maplist(capitalize_atom_words, RawTests, CapitalizedTests),
    reply_json_dict(_{tests: CapitalizedTests}).

% Capitalize labels
capitalize_atom_words(Atom, Capitalized) :-
    atomic_list_concat(Parts, '_', Atom),
    maplist(cap_word, Parts, CapitalizedParts),
    atomic_list_concat(CapitalizedParts, ' ', Capitalized).

cap_word(Part, Capitalized) :-
    atom_chars(Part, [H|T]),
    upcase_atom(H, UH),
    atom_chars(Capitalized, [UH|T]).
