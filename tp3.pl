%list_size(+List, ?Size)
    list_size([], 0).
    list_size([_|X] , L) :- list_size(X, N), L is N + 1.

%list_sum(+List, ?Sum)
    list_sum([], 0).
    list_sum([H|T], S) :- number(H), list_sum(T, N), S is H + N.
    list_sum([H|_], _) :- \+ number(H), writeln('Error: List contains a non-number element.'), fail.

%list_prod(+List, ?Prod)
    list_prod([], 1).
    list_prod([H|T] , P) :- number(H), list_prod(T, N), P is H * N.
    list_prod([H|_], _) :- \+ number(H), writeln('Error: List contains a non-number element.'), fail.

%inner_product(+List1, +List2, ?Result)
    inner_product([], [], 1).
    inner_product([X1|Y1], [X2,Y2], R) :- P is X1 * X2, inner_product(Y1, Y2, N), R is P + N.

%count(+Elem, +List, ?N)
    count(_, [], 0).
    count(X, [X|T], N) :- !, count(X, T, N1), N is N1 + 1.
    count(X, [_|T], N) :- count(X, T, N). 

%invert(+List1, ?List2)
    invert([], []).
    invert([H|T], RevList) :- invert(T, RevT), append(RevT, [H], RevList).

%del_one(+Elem, +List1, ?List2)
    del_one(_, [], []).
    del_one(R, [R|T], T).
    del_one(R, [H|T], [H|T2]) :- H \= R, del_one(R, T, T2).

%del_all(+Elem, +List1, ?List2)
    del_all(_, [], []).
    del_all(R, [R|T], T2) :- del_all(R, T, T2).
    del_all(R, [H|T], [H|T2]) :- H \= R, del_all(R, T, T2).

%del_all_list(+ListElems, +List1, ?List2)
    del_all_list(_, [], []).
    del_all_list(ListElems, [H|T1], List2) :- member(H, ListElems), !, del_all_list(ListElems, T1, List2).
    del_all_list(ListElems, [H|T1], [H|T2]) :- del_all_list(ListElems, T1, T2).

%del_dups(+List1, ?List2)
    del_dups([], []).
    del_dups([H|T1], List2) :- member(H, T1), !, del_dups(T1, List2).
    del_dups([H|T1], [H|T2]) :- del_dups(T1, T2).

%list_perm(+L1, +L2)
    list_perm([], []).
    list_perm(L1, L2) :- length(L1, Len1), length(L2, Len2), Len1 = Len2, is_permutation(L1, L2).
    is_permutation([], []).
    is_permutation([H|T], L2) :- member(H, L2), del_one(H, L2, NewL2), is_permutation(T, NewL2).

%replicate(+Amount, +Elem, ?List)
    replicate(0, _, []).
    replicate(Amount, Elem, [Elem|Rest]) :- Amount > 0, NewAmount is Amount - 1, replicate(NewAmount, Elem, Rest).

%intersperse(+Elem, +List1, ?List2)
    intersperse().

%insert_elem(+Index, +List1, +Elem, ?List2)
    insert_elem().

%delete_elem(+Index, +List1, ?Elem, ?List2)
    delete_elem().

%replace(+List1, +Index, ?Old, +New, ?List2)
    replace().
