/*Minxuan Zhao 
Assignment 1*/

create table catalog (
    cno char(5) not null,
    ctitle char(30),
    constraint pk_catalog primary key (cno));

create table students (
    sid char(4) not null,
    fname char(30),
    lname char(30),
    minit char(1),
    constraint pk_students primary key (sid));

create table courses (
    term char(10) not null,
    sectno char(30),
    cno char(5),
    a number(5,0),
    b number(5,0),
    c number(5,0),
    d number(5,0),
    constraint pk_courses primary key(term, sectno),
    constraint course_cno foreign key (cno) references catalog (cno));

create table components (
    term char(10) not null,
    sectno char(30) not null,
    compname char(30) not null,
    maxpoints number(10,2),
    weight number(10,2),
    constraint pk_components primary key (term, sectno,compname),
    constraint components_course foreign key (term, sectno) references courses(term,sectno));

create table enrolls (
    sid char(4) not null,
    term char(10) not null,
    sectno char(30) not null,
    constraint pk_enrolls primary key (sid, term, sectno),
    constraint enrolls_sid foreign key (sid) references students (sid),
    constraint enrolls_course foreign key (term, sectno) references courses (term, sectno));

create table scores (
    sid char(4) not null,
    term char(10) not null,
    sectno char(30) not null,
    compname char(30) not null,
    points number(10,2),
    constraint pk_scores primary key (sid, term, sectno, compname),
    constraint scores_student foreign key (sid) references students (sid),
    constraint scores_components foreign key (term, sectno, compname) references components (term, sectno, compname));
    
insert into CATALOG values ('AC200', 'Fixed-Asset Accounting');
insert into CATALOG values ('CS226', 'Introduction to Programming I');
insert into CATALOG values ('CS227', 'Introduction to Programming II');
insert into CATALOG values ('CS343', 'Introduction to Linux');
insert into CATALOG values ('MK173', 'Hi-Tech Marketing');

insert into STUDENTS values ('1111', 'Susan', 'Jones', 'B');
insert into STUDENTS values ('2222', 'Samuel', 'Corn', 'A');
insert into STUDENTS values ('3333', 'Willie', 'Smith', '');
insert into STUDENTS values ('4444', 'Jerome', 'Franks', 'B');
insert into STUDENTS values ('5555', 'Sally', 'Williams', 'G');
insert into STUDENTS values ('6666', 'Willie', 'Brown', 'F');
insert into STUDENTS values ('7777', 'Jonathan', 'Miller', '');
insert into STUDENTS values ('8888', 'Mary', 'Jones', 'C');
insert into STUDENTS values ('9999', 'Ada', 'Jones', '');

insert into COURSES values ('F16', '1031', 'CS226', 90, 80, 65, 50);
insert into COURSES values ('F16', '1032', 'CS226', 90, 80, 65, 50);
insert into COURSES values ('S17', '1031', 'CS227', 90, 80, 70, 55);
insert into COURSES values ('F17', '1032', 'CS343', 92, 82, 75, 60);

insert into COMPONENTS values ('F16', '1031', 'Exam1', 100, 30);
insert into COMPONENTS values ('F16', '1031', 'Quizzes', 80, 20);
insert into COMPONENTS values ('F16', '1031', 'Final', 100, 50);
insert into COMPONENTS values ('F16', '1032', 'Programs', 400, 40);
insert into COMPONENTS values ('F16', '1032', 'Midterm', 100, 20);
insert into COMPONENTS values ('F16', '1032', 'Final', 100, 40);
insert into COMPONENTS values ('S17', '1031', 'Exam', 100, 50);
insert into COMPONENTS values ('S17', '1031', 'Project', 100, 50);
insert into COMPONENTS values ('F17', '1032', 'Paper', 100, 100);

insert into enrolls values ('1111', 'F16', '1031');
insert into enrolls values ('2222', 'F16', '1031');
insert into enrolls values ('4444', 'F16', '1031');
insert into enrolls values ('5555', 'F16', '1032');
insert into enrolls values ('6666', 'F16', '1032');
insert into enrolls values ('3333', 'F16', '1032');
insert into enrolls values ('1111', 'S17', '1031');
insert into enrolls values ('3333', 'S17', '1031');
insert into enrolls values ('3333', 'F17', '1032');

insert into scores values ('1111', 'F16', '1031', 'Exam1', 90);
insert into scores values ('1111', 'F16', '1031', 'Quizzes', 75);
insert into scores values ('1111', 'F16', '1031', 'Final', 95);
insert into scores values ('2222', 'F16', '1031', 'Exam1', 70);
insert into scores values ('2222', 'F16', '1031', 'Quizzes', 40);
insert into scores values ('2222', 'F16', '1031', 'Final', 82);
insert into scores values ('4444', 'F16', '1031', 'Exam1', 83);
insert into scores values ('4444', 'F16', '1031', 'Quizzes',71);
insert into scores values ('4444', 'F16', '1031', 'Final', 74);
insert into scores values ('5555', 'F16', '1032', 'Programs', 400);
insert into scores values ('5555', 'F16', '1032', 'Midterm', 95);
insert into scores values ('5555', 'F16', '1032', 'Final', 99);
insert into scores values ('6666', 'F16', '1032', 'Programs', 340);
insert into scores values ('6666', 'F16', '1032', 'Midterm', 65);
insert into scores values ('6666', 'F16', '1032', 'Final', 95);
insert into scores values ('3333', 'F16', '1032', 'Programs', 380);
insert into scores values ('3333', 'F16', '1032', 'Midterm', 75);
insert into scores values ('3333', 'F16', '1032', 'Final', 88);
insert into scores values ('1111', 'S17', '1031', 'Exam', 80);
insert into scores values ('1111', 'S17', '1031', 'Project', 90);
insert into scores values ('3333', 'S17', '1031', 'Exam', 80);
insert into scores values ('3333', 'S17', '1031', 'Project', 85);

select * from catalog;
select * from students;
select * from courses;
select * from components;
select * from enrolls;
select * from scores;

