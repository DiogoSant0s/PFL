male(frank).
male(jay).
male(javier).
male(barb).
male(phil).
male(mitchel).
male(joe).
male(pameron).
male(dylan).
male(alex).
male(luke).
male(rexford).
male(calhoun).
male(george).

female(grace).
female(deDe).
female(gloria).
female(merle).
female(claire).
female(manny).
female(cameron).
female(bo).
female(haley).
female(lily).
female(poppy).

parent(grace,phil).
parent(frank,phil).
parent(deDe,claire).
parent(jay,claire).
parent(deDe,mitchell).
parent(jay,mitchell).
parent(jay,joe).
parent(gloria,joe).
parent(gloria,manny).
parent(javier,manny).
parent(barb,cameron).
parent(merle,cameron).
parent(barb,pameron).
parent(merle,pameron).

parent(phil,haley).
parent(claire,haley).
parent(phil,alex).
parent(claire,alex).
parent(phil,luke).
parent(claire,luke).
parent(mitchell,lily).
parent(cameron,lily).
parent(mitchell,rexford).
parent(cameron,rexford).
parent(pameron,calhoun).
parent(bo,calhoiun).

parent(dylan,george).
parent(haley,george).
parent(dylan,poppy).
parent(haley,poppy).


father(X,Y) :- parent(X,Y), male(X).
mother(X,Y) :- parent(X,Y), female(X).

grandparent(X,Y) :- parent(X,Z), parent(Z,Y).

grandfather(X,Y) :- grandparent(X,Y), male(X).
grandmother(X,Y) :- grandparent(X,Y), female(X).

siblings(X,Y) :- father(F,X), father(F,Y), mother(M,X), mother(M,Y), X \= Y.
halfsiblings(X,Y) :- parent(Z,X), parent(Z,Y), \+(siblings(X,Y)), X \= Y.

cousins(X,Y) :- parent(U,X), siblings(U,P), parent(P,Y).

uncle(X,Y) :- siblings(X,Z), parent(Z,Y), male(X).
aunt(X,Y) :- siblings(X,Z), parent(Z,Y), female(X).

nephew(X,Y) :- siblings(Z,Y), parent(Z,X), male(X).
niece(X,Y) :- siblings(Z,Y), parent(Z,X), female(X).
