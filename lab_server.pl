:- use_module(library(http/thread_httpd)).
:- use_module(library(http/http_dispatch)).
:- use_module(library(http/http_json)).
:- use_module(library(http/http_parameters)).
:- use_module(library(http/json_convert)).
:- use_module(library(http/json)).
:- use_module(library(lists)).
:- use_module(library(apply)).

% Load the medical knowledge base
:- consult('medical_kb.pl').

% Serve index.html at the root
:- http_handler(root(.), serve_index, []).

serve_index(_Request) :-
    open('index.html', read, Stream),
    read_string(Stream, _, HTML),
    close(Stream),
    format('Content-type: text/html~n~n'),
    format('~s', [HTML]).

% HTTP handlers
:- http_handler(root(abnormal), handle_abnormal, []).
:- http_handler(root(tests), handle_get_tests, []).

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

% Range fallback logic
find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, Unit) :-
    (   normal_range(Test, Min, Max, AgeGroup, Gender, Unit)
    ;   normal_range(Test, Min, Max, AgeGroup, both, Unit)
    ;   normal_range(Test, Min, Max, _, Gender, Unit)
    ;   normal_range(Test, Min, Max, _, both, Unit)
    ),
    !.

% Abnormal predicate for CLI use
abnormal(_, TestRaw, Value, Status, Unit) :-
    normalize_test_name(TestRaw, Test),
    patient(_, Age, Gender),
    age_group(Age, AgeGroup),
    find_normal_range_with_fallback(Test, AgeGroup, Gender, Min, Max, Unit),
    (Value < Min -> Status = low ;
     Value > Max -> Status = high ;
     Status = normal).

% Normalize names
normalize_test_name(Raw, Cleaned) :-
    (   atom(Raw) -> AtomRaw = Raw ; atom_string(Raw, AtomRaw)
    ),
    downcase_atom(AtomRaw, Lower),
    atom_chars(Lower, Chars),
    maplist(replace_non_alnum, Chars, NormalizedChars),
    atom_chars(Cleaned, NormalizedChars).

replace_non_alnum(Char, '_') :- \+ char_type(Char, alnum), !.
replace_non_alnum(Char, Char).
