:- consult('tp1.pl').

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

%spouse_children(+Person, -SC)
    spouse_children(Person, Spouse/Children) :- parent(Person, Child), parent(Spouse, Child), Person \= Spouse, findall(Child, parent(Person, Child), Children).

%immediate_family(+Person, -PC)
    immediate_family(Person, Parents-SpousesChildren) :- findall(Parent, parent(Parent, Person), Parents), 
        findall(Spouse-Children, (parent(Person, Child), parent(Spouse, Child), Person \= Spouse, findall(Child, parent(Person, Child), Children)), SpousesChildren).

%del_dups(+List1, ?List2)
    del_dups([], []).
    del_dups([H|T1], List2) :- member(H, T1), !, del_dups(T1, List2).
    del_dups([H|T1], [H|T2]) :- del_dups(T1, T2).

%count_children(+Person, -Count)
    count_children(Person, Count) :- findall(_, parent(Person, _), Children), length(Children, Count).

%parents_of_two(-Parents)
    parents_of_two(Parents) :- findall(Person, (parent(Person, _), count_children(Person, Count), Count >= 2), ParentsList), del_dups(ParentsList, Parents).

%teachers(-Teachers)
    teachers(Teachers) :- findall(Teacher, teaches(_, Teacher), Teachers1), del_dups(Teachers1, Teachers).

%students_of(+Teacher, -Students)
    students_of(Teacher, Students) :- findall(Student, student_of_professor(Student, Teacher), Students1), del_dups(Students1, Students).

%teachers_of(+Student, -Teachers)
    teachers_of(Student, Teachers) :- findall(Teacher, student_of_professor(Student, Teacher), Teachers).

%common_courses(+Student1, +Student2, -Courses)
    common_courses(Student1, Student2, Courses) :- findall(Course, (attends(Course, Student1), attends(Course, Student2)), CommonCourses), del_dups(CommonCourses, Courses).

%more_than_one_course(-L)
    more_than_one_course(L) :- findall(Student, students_in_multiple_courses(Student), L1), del_dups(L1, L).

%strangers(-L)
    strangers(L) :- findall((S1, S2), (attends(_, S1), attends(_, S2), S1 \= S2, common_courses(S1, S2, Courses), Courses = []), L1), del_dups(L1, L).

%good_groups(-L)
    good_groups(L) :- findall(S1, (attends(_, S1), attends(_, S2), S1 \= S2, common_courses(S1, S2, Courses), length(Courses, N), N > 1), L1), del_dups(L1, L).

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

%translate_day(DayOfWeek, NewDayOfWeek)
    translate_day('1 Mon', 'Mon').
    translate_day('2 Tue', 'Tue').
    translate_day('3 Wed', 'Wed').
    translate_day('4 Thu', 'Thu').
    translate_day('5 Fri', 'Fri').

%same_day(+Course1,  +Course2)
    same_day(Course1, Course2) :- class(Course1, _, Day, _, _), class(Course2, _, Day, _, _), Course1 \= Course2.

%daily_courses(+Day, -Courses)
    daily_courses(Day, Courses) :- translate_day(DayInternal, Day), setof(Course, Course^Type^Time^Duration^class(Course, Type, DayInternal, Time, Duration), Courses).

%short_classes(-L)
    short_classes(L) :- findall(UC-Day/Time, (class(UC, _, InternalDay, Time, Duration), Duration < 2, translate_day(InternalDay, Day)), L).

%course_classes(+Course, -Classes)
    course_classes(Course, Classes) :- findall(Day/Time-Type, (class(Course, Type, InternalDay, Time, _), translate_day(InternalDay, Day)), Classes).

%courses(-L)
    courses(Courses) :- setof(Course, Type^Day^Time^Duration^class(Course, Type, Day, Time, Duration), Courses).

%get_classes(-SortedClasses)
    get_classes(SortedClasses) :- setof((TranslatedDay, Time, Course, ClassType, Duration), (class(Course, ClassType, DayOfWeek, Time, Duration), translate_day(DayOfWeek, TranslatedDay)), SortedClasses).

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

%flight(origin, destination, company, code, hour, duration) 
    flight(porto, lisbon, tap, tp1949, 1615, 60).
    flight(lisbon, madrid, tap, tp1018, 1805, 75).
    flight(lisbon, paris, tap, tp440, 1810, 150).
    flight(lisbon, london, tap, tp1366, 1955, 165).
    flight(london, lisbon, tap, tp1361, 1630, 160).
    flight(porto, madrid, iberia, ib3095, 1640, 80).
    flight(madrid, porto, iberia, ib3094, 1545, 80).
    flight(madrid, lisbon, iberia, ib3106, 1945, 80).
    flight(madrid, paris, iberia, ib3444, 1640, 125).
    flight(madrid, london, iberia, ib3166, 1550, 145).
    flight(london, madrid, iberia, ib3163, 1030, 140).
    flight(porto, frankfurt, lufthansa, lh1177, 1230, 165).

%get_all_nodes(-ListOfAirports)

%most_diversified(-Company)

%find_flights(+Origin, +Destination, -Flights)

%find_flights_bfs(+Origin, +Destination, -Flights)

%find_all_flights (+Origin, +Destination, -ListOfFlights)

%find_flights_least_stops(+Origin, +Destination, -ListOfFlights)

%find_flights_stops(+Origin, +Destination, +Stops, -ListFlights)

%find_circular_trip (+MaxSize, +Origin, -Cycle)

%find_circular_trips(+MaxSize, +Origin, -Cycles)

%strongly_connected(+ListOfNodes)

%strongly_connected_components(-Components)

%bridges(-ListOfBridges)

%unifiable(+L1, +Term, -L2)

%missionaries_and_cannibals(-Moves)

%steps(+Steps, -N, -L)

%sliding_puzzle(+Initial, -Moves)
