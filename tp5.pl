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
parent(bo,calhoun).

parent(dylan,george).
parent(haley,george).
parent(dylan,poppy).
parent(haley,poppy).

%children(+Person, -Children)
    children(Person, Children) :- findall(Child, parent(Person, Child), Children).

%children_of(+ListOfPeople, -ListOfPairs)
    children_of([], []).
    children_of([Person|Rest], [Person-Children|Pairs]) :- children(Person, Children), children_of(Rest, Pairs).

%family(-F)
    family(Family) :- findall(Person, (parent(Person, _); parent(_, Person)), People), del_dups(People, Family).

%couple(?C)
    couple(X-Y) :- parent(X, Child), parent(Y, Child), X \= Y, X @< Y.

%couples(-List)
    couples(List) :- findall(Couple, couple(Couple), Couples), sort(Couples, List).

%spouse_children(+Person,  -SC)
    spouse_children(Person, Spouse/Children) :- parent(Person, Child), parent(Spouse, Child), Person \= Spouse, findall(Child, parent(Person, Child), Children).

%immediate_family(+Person, -PC)
    immediate_family(Person, Parents-SpousesChildren) :- findall(Parent, parent(Parent, Person), Parents), 
        findall(Spouse-Children, (parent(Person, Child), parent(Spouse, Child), Person \= Spouse, findall(Child, parent(Person, Child), Children)), SpousesChildren).

del_dups([], []).
del_dups([H|T1], List2) :- member(H, T1), !, del_dups(T1, List2).
del_dups([H|T1], [H|T2]) :- del_dups(T1, T2).

count_children(Person, Count) :- findall(_, parent(Person, _), Children), length(Children, Count).

%parents_of_two(-Parents)
    parents_of_two(Parents) :- findall(Person, (parent(Person, _), count_children(Person, Count), Count >= 2), ParentsList), del_dups(ParentsList, Parents).

%class(Course, ClassType, DayOfWeek, Time, Duration) 
    class(pfl, t, '2 Tue', 15, 2).
    class(pfl, tp, '2 Tue', 10.5, 2).
    class(lbaw, t, '3 Wed', 10.5, 2).
    class(lbaw, tp, '3 Wed', 8.5, 2).
    class(ipc, t, '4 Thu', 14.5, 1.5).
    class(ipc, tp, '4 Thu', 16, 1.5).
    class(fsi, t, '1 Mon', 10.5, 2).
    class(fsi, tp, '5 Fri', 8.5, 2).
    class(rc, t, '5 Fri', 10.5, 2).
    class(rc, tp, '1 Mon', 8.5, 2).

%same_day(+Course1,  +Course2)
    same_day(Course1, Course2) :- class(Course1, _, Day, _, _), class(Course2, _, Day, _, _), Course1 \= Course2.

%daily_courses(+Day, -Courses)
    daily_courses(Day, Courses) :- setof(Course, Course^Type^Time^Duration^class(Course, Type, Day, Time, Duration), Courses).

%short_classes(-L)
    short_classes(L) :- findall(UC-Day/Time, (class(UC, _, Day, Time, Duration), Duration < 2), L).

%course_classes(+Course, -Classes)
    course_classes(Course, Classes) :- findall(Day/Time-Type, class(Course, Type, Day, Time, _), Classes).

%courses(-L)
    courses(Courses) :- setof(Course, Type^Day^Time^Duration^class(Course, Type, Day, Time, Duration), Courses).

%get_classes(-SortedClasses)
    get_classes(SortedClasses) :- setof((DayOfWeek, Time, Course, ClassType, Duration), class(Course, ClassType, DayOfWeek, Time, Duration), SortedClasses).

%print_class(+(DayOfWeek, Time, Course, ClassType, Duration))
    print_class((DayOfWeek, Time, Course, ClassType, Duration)) :- format('~w (~w): ~w at ~w for ~w hours~n', [Course, ClassType, DayOfWeek, Time, Duration]).

%schedule
    schedule :- get_classes(SortedClasses), maplist(print_class, SortedClasses).

%class_ongoing(+Day, +Time, -Course, -ClassType, -Start, -Duration)
    class_ongoing(Day, Time, Course, ClassType, Start, Duration) :- class(Course, ClassType, Day, Start, Duration), End is Start + Duration, Time >= Start, Time < End.

%find_class
    find_class :- writeln('Enter the day of the week (e.g., \'2 Tue\'): '), read(Day), writeln('Enter the time (as a number, e.g., 10.5): '), read(Time),
        (class_ongoing(Day, Time, Course, ClassType, Start, Duration) -> format('Class found: ~w (~w), starts at ~w, duration ~w hours~n', [Course, ClassType, Start, Duration]); 
        writeln('No class is taking place at this time.')).
