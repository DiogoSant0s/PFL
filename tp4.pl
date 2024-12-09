%max(+A, +B, +C, ?Max)
    max(A, B, C, Max) :- A > B,	A > C, Max = A.
    max(A, B, C, Max) :- A > B, Max = C.
    max(_, B, C, Max) :- B > C, Max = B.
    max(_, _, C, Max) :- Max = C.

%print_n(+N, +S)
    print_n(0, _).
    print_n(N, S) :- N > 0, write(S), N1 is N - 1, print_n(N1,S).

%write_text(+Text)
    write_text([]).
    write_text([H|T]) :- put_code(H), write_text(T).

%print_text(+Text, +Symbol, +Padding)
    print_text(Text, Symbol, Padding) :- write(Symbol), print_n(Padding, ' '), write_text(Text), print_n(Padding, ' '), write(Symbol).

%list_size(+List, ?Size)
    list_size([], 0).
    list_size([H|T], S) :- list_size(T, S1), S is 1 + S1.

%print_banner(+Text, +Symbol, +Padding)
    print_banner(Text, Symbol, Padding) :-
        list_size(Text, Text_size),
        print_n((1 + Padding) * 2 + Text_size, Symbol), nl,
        write(Symbol), print_n(Padding * 2 + Text_size, ' '), write(Symbol), nl,
        print_text(Text, Symbol, Padding), nl,
        write(Symbol), print_n(Padding * 2 + Text_size, ' '), write(Symbol), nl,
        print_n((1 + Padding) * 2 + Text_size, Symbol).

%read_number(-X)
    read_num(10, Acc) :- write(Acc), !.
    read_num(X, Acc) :- N is X - 48, between(0, 9, N) == True, NewAcc is 10 * Acc + N, get_code(Y), read_num(Y, NewAcc).
    read_number(X) :- get_code(X), read_num(X, 0), nl, !, fail.

%read_until_between(+Min, +Max, -Value)

%read_string(-X)

%banner()

%print_multi_banner(+ListOfTexts, +Symbol, +Padding)

%oh_christmas_tree(+N)

%print_full_list(+L)

%print_list(+L)

%print_matrix(+M)

%print_numbered_matrix(+L)

%print_list(+L,  +S,  +Sep,  +E)

