%male(Man)
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

%female(Woman)
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

%parent(Parent, Child)
    parent(grace, phil).
    parent(frank, phil).
    parent(deDe, claire).
    parent(jay, claire).
    parent(deDe, mitchell).
    parent(jay, mitchell).
    parent(jay, joe).
    parent(gloria, joe).
    parent(gloria, manny).
    parent(javier, manny).
    parent(barb, cameron).
    parent(merle, cameron).
    parent(barb, pameron).
    parent(merle, pameron).
    parent(phil, haley).
    parent(claire, haley).
    parent(phil, alex).
    parent(claire, alex).
    parent(phil, luke).
    parent(claire, luke).
    parent(mitchell, lily).
    parent(cameron, lily).
    parent(mitchell, rexford).
    parent(cameron, rexford).
    parent(pameron, calhoun).
    parent(bo, calhoiun).
    parent(dylan, george).
    parent(haley, george).
    parent(dylan, poppy).
    parent(haley, poppy).

%father(+Father, -Child)
    father(Father, Child) :- parent(Father, Child), male(Father).

%mother(+Mother, -Child)
    mother(Mother, Child) :- parent(Mother, Child), female(Mother).

%grandparent(+Grandparent, -Grandchild)
    grandparent(Grandparent, Grandchild) :- parent(Grandparent, Parent), parent(Parent, Grandchild).

%grandfather(+Grandfather, -Grandchild)
    grandfather(Grandfather, Grandchild) :- grandparent(Grandfather, Grandchild), male(Grandfather).

%grandmother(+Grandmother, -Grandchild)
    grandmother(Grandmother, Grandchild) :- grandparent(Grandmother, Grandchild), female(Grandmother).

%siblings(+Child1, -Child2)
    siblings(Child1, Child2) :- father(Father, Child1), father(Father, Child2), mother(Mother, Child1), mother(Mother, Child2), Child1 \= Child2.

%halfsiblings(+Child1, -Child2)
    halfsiblings(Child1, Child2) :- parent(Parent, Child1), parent(Parent, Child2), \+(siblings(Child1, Child2)), Child1 \= Child2.

%cousins(+Cousin1, -Cousin2)
    cousins(Cousin1, Cousin2) :- parent(Parent1, Cousin1), siblings(Parent1, Parent2), parent(Parent2, Cousin2).

%uncle(+Uncle, -Child)
    uncle(Uncle, Child) :- siblings(Uncle, Parent), parent(Parent, Child), male(Uncle).

%aunt(+Aunt, -Child)
    aunt(Aunt, Child) :- siblings(Aunt, Parent), parent(Parent, Child), female(Aunt).

%nephew(+Nephew, -Adult)
    nephew(Nephew, Adult) :- siblings(Parent, Adult), parent(Parent, Nephew), male(Nephew).

%niece(+Niece, -Adult)
    niece(Niece, Adult) :- siblings(Parent, Adult), parent(Parent, Niece), female(Niece).

%teaches(Class, Professor)
    teaches(algorithms, adalberto).
    teaches(databases, bernardete).
    teaches(compilers, capitolino).
    teaches(statistics, dalmindo).
    teaches(networks, ermelinda).

%attends(Class, Student)
    attends(algorithms, alberto).
    attends(algorithms, bruna).
    attends(algorithms, cristina).
    attends(algorithms, diogo).
    attends(algorithms, eduarda).
    attends(databases, antonio).
    attends(databases, bruno).
    attends(databases, cristina).
    attends(databases, duarte).
    attends(databases, eduardo).
    attends(compilers, alberto).
    attends(compilers, bernardo).
    attends(compilers, clara).
    attends(compilers, diana).
    attends(compilers, eurico).
    attends(statistics, antonio).
    attends(statistics, bruna).
    attends(statistics, claudio).
    attends(statistics, duarte).
    attends(statistics, eva).
    attends(networks, alvaro).
    attends(networks, beatriz).
    attends(networks, claudio).
    attends(networks, diana).
    attends(networks, eduardo).

%student_of_professor(+Student, -Professor)
    student_of_professor(Student, Professor) :- attends(Class, Student), teaches(Class, Professor).

%student_of_both(+Professor1, +Professor2, -Student)
    student_of_both(Professor1, Professor2, Student) :- teaches(Class1, Professor1), teaches(Class2, Professor2), attends(Class1, Student), attends(Class2, Student), Professor1 \= Professor2.

%colleagues(?Person1, ?Person2)
    colleagues(Student1, Student2) :- attends(Class, Student1), attends(Class, Student2), Student1 \= Student2.
    colleagues(Professor1, Professor2) :- teaches(_, Professor1), teaches(_, Professor2), Professor1 \= Professor2.

%students_in_multiple_courses(-Student)
    students_in_multiple_courses(Student) :- attends(Class1, Student), attends(Class2, Student), Class1 \= Class2.

%job(Role, Name)
    job(technician, eleuterio).
    job(technician, juvenaldo).
    job(analyst, leonilde).
    job(analyst, marciliano).
    job(engineer, osvaldo).
    job(engineer, porfirio).
    job(engineer, reginaldo).
    job(supervisor, sisnando).
    job(chief_supervisor, gertrudes).
    job(secretary, felismina).
    job(director, asdrubal).

%supervised_by(Role1, Role2)
    supervised_by(technician, engineer).
    supervised_by(engineer, supervisor).
    supervised_by(analyst, supervisor).
    supervised_by(supervisor, chief_supervisor).
    supervised_by(chief_supervisor, director).
    supervised_by(secretary, director).

%direct_supervisor(?Supervisor, ?Supervisee)
    direct_supervisor(Supervisor, Supervisee) :- job(Role1, Supervisor), job(Role2, Supervisee), supervised_by(Role2, Role1).

%same_supervisor_job(?Person1, ?Person2)
    same_supervisor_job(Person1, Person2) :- job(RoleX, Person1), job(RoleY, Person2), supervised_by(RoleX, SupervisorRole), supervised_by(RoleY, SupervisorRole).

%supervises_multiple_jobs(?Supervisor)
    supervises_multiple_jobs(Supervisor) :- job(Role1, Supervisor), supervised_by(Role2, Role1), supervised_by(Role3, Role1), Role2 \= Role3.

%supervisor_of_supervisor(?Supervisor, ?Employee)
    supervisor_of_supervisor(Supervisor, Employee) :- job(Role1, Supervisor), job(Role3, Employee), supervised_by(Role3, Role2), supervised_by(Role2, Role1).
