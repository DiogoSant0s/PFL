%factorial(+N, -F)
  factorial(0,0).
  factorial(1,1).
  factorial(N, F) :- N > 1, N1 is N-1, factorial(N1, F1), F is N * F1.

  factorial2(0, 0).
  factorial2(N, F) :- N > 0, fact(N, 1, F).
  fact(1, F, F).
  fact(N, Acc, F) :- N > 1, N1 is N-1, Acc1 is N * Acc, fact(N1, Acc1, F).

%sum_rec(+N, -Sum).
  sum_rec(0, 0).
  sum_rec(N, Sum) :- N > 0,  N1 is N-1, sum_rec(N1, Sum1), Sum is N + Sum1.

  sum_rec2(N, Sum) :- sum_r(N, 0, Sum).
  sum_r(0, Sum, Sum).
  sum_r(N, Acc, Sum) :- N > 0,  N1 is N - 1, Acc1 is N + Acc, sum_r(N1, Acc1, Sum).

%pow_rec(+X, +Y, -P).
  pow_rec(0, Y, 0).
  pow_rec(X, 0, 1).
  pow_rec(X, 1, X) :- X > 0.
  pow_rec(X, Y, P) :- X > 1, Y > 1, Y1 is Y - 1, pow_rec(X, Y1, P1), P is X * P1.

  pow_rec2(0, Y, 0).
  pow_rec2(X, 0, 1).
  pow_rec2(X, Y, P) :- X > 0, Y > 0, pow_r(X, Y, 1, P).
  pow_r(X, 0, P, P).
  pow_r(X, Y, Acc, P) :- X > 0, Y > 0, Y1 is Y - 1, Acc1 is X * Acc, pow_r(X, Y1, Acc1, P).

%square_rec(+N, -S).
  square_rec(0, 0).
  square_rec(N, S) :- N > 0,  N1 is N - 1, square_rec(N1, S1), S is S1 + N + N - 1.

  square_rec2(N, S) :- square_r(N, 0, S).
  square_r(0, S, S).
  square_r(N, Acc, S) :- N > 0, N1 is N - 1, Acc1 is Acc + N + N - 1, square_r(N1, Acc1, S).

%fibonacci(+N, -F).
  fibonacci(0, 0).
  fibonacci(1, 1).
  fibonacci(N, F) :- N > 1,  N1 is N - 1, fibonacci(N1, F1), N2 is N - 2, fibonacci(N2, F2), F is F1 + F2.

  fibonacci2(N, F) :- fib(N, 0, 1, F).
  fib(0, F, B, F).
  fib(1, A, F, F).
  fib(N, A, B, F) :- N > 1,  N1 is N - 1, C is A + B, fib(N1, B, C, F).

%collatz(+N, -S).
  collatz(1, 0).
  collatz(N, S) :- N > 1, N / 2 =:= 0,  N1 is N / 2, collatz(N1, S1), S is S1 + 1.
  collatz(N, S) :- N > 1, N / 2 =:= 1,  N1 is 3 * N + 1, collatz(N1, S1), S is S1 + 1.

%is_prime(+X).
  is_prime(X) :- X > 1, not(divisors(X, 2)).
  divisors(X, Y) :- Y * Y <= X, (0 is X mod Y; Y1 is Y + 1, divisors(X, Y1)).

%gcd(+X, +Y, -G)
  gcd(X, 0, X) :- !.
  gcd(X, Y, G) :-
    Y > 0,
    R is X mod Y,
    gcd(Y, R, G).

%lcm(+X, +Y, -M)
  lcm(0, _, 0) :- !.
  lcm(_, 0, 0) :- !.
  lcm(X, Y, M) :-
      gcd(X, Y, G),
      M is (X * Y) // G.
