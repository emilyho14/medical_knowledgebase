:- use_module(lab_server).

% Backwards-compatible launcher for the canonical HTTP server.
start_server(Port) :-
    lab_server:start_server(Port).
