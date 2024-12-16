:- consult('tp1.pl').
:- dynamic male/1, female/1, parent/2.

%add_person(+Gender, +Name)
    add_person(male, Name) :- \+ male(Name), assertz(male(Name)).
    add_person(female, Name) :- \+ female(Name), assertz(female(Name)).
    add_person(_, _) :- fail.

%add_parents(+Person, +Parent1, +Parent2)
    add_parents(Person, Parent1, Parent2) :-
        (\+ male(Parent1), \+ female(Parent1) -> write('Parent '), write(Parent1), write(' does not exist. Enter gender (male/female): '), read(Gender1), add_person(Gender1, Parent1)
        ; true),
        (\+ male(Parent2), \+ female(Parent2) -> write('Parent '), write(Parent2), write(' does not exist. Enter gender (male/female): '), read(Gender2), add_person(Gender2, Parent2)
        ; true),
        (male(Parent1), female(Parent2) -> true; female(Parent1), male(Parent2) -> true; write('A person must have one male and one female parent.'), nl, fail),
        (\+ parent(Parent1, Person) -> assertz(parent(Parent1, Person)); true),
        (\+ parent(Parent2, Person) -> assertz(parent(Parent2, Person)); true).

%remove_person
    remove_person :-
        write('Enter the name of the person to remove: '),
        read(Name),
        (male(Name); female(Name) -> retractall(male(Name)), retractall(female(Name)), retractall(parent(Name, _)), retractall(parent(_, Name)), 
            write(Name), write(' has been removed from the knowledge base.'), nl;   
            write(Name), write(' does not exist in the knowledge base.'), nl
        ).

%update_birthdates
    update_birthdates :-
        findall(Name, (male(Name); female(Name)), Names),
        update_birthdates_helper(Names),
        retractall(male(_)), retractall(female(_)),
        findall((Name, Year), male_temp(Name, Year), Males), findall((Name, Year), female_temp(Name, Year), Females),
        maplist(assert_male, Males), maplist(assert_female, Females),
        retractall(male_temp(_, _)), retractall(female_temp(_, _)).

    update_birthdates_helper([]).
    update_birthdates_helper([Name | Rest]) :- write('What is the year of birth of '), write(Name), write('? '), read_valid_year(Year),
        (male(Name) -> assertz(male_temp(Name, Year)); assertz(female_temp(Name, Year))), update_birthdates_helper(Rest).

    read_valid_year(Year) :- read(Input), (integer(Input) -> Year = Input; write('Invalid input. Please enter a valid year: '), nl, read_valid_year(Year)).

    assert_male((Name, Year)) :- assertz(male(Name, Year)).
    assert_female((Name, Year)) :- assertz(female(Name, Year)).

%print_descendents(+Person)
    print_descendents(Person) :- writeln('Children:'), parent(Person, Child), tab(4), writeln(Child), fail.
    print_descendents(Person) :- writeln('Grandchildren:'), parent(Person, Child), parent(Child, Grandchild), tab(4), writeln(Grandchild), fail.
    print_descendents(_).

%map(+Pred, +List1, ?List2)

%fold(+Pred,  +StartValue,  +List,  ?FinalValue)

%separate(+List, +Pred, -Yes, -No)

%take_while(+Pred, +List, -Front, -Back)

%ask_execute

%tree_size(+Tree, -Size)

%tree_map(+Pred, +Tree, ?NewTree)

%tree_value_at_level(+Tree, ?Value, ?Level)

:-op(1050, fx, 'if'). 
:-op(1000, xfy, 'then'). 
:-op(1100, xfy, 'else').

if If then Then else _ :- If, !, Then.
if _ then _ else Else :- !, Else.
if If then Then :- If, !, Then.
