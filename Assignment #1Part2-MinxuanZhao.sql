--Minxuan Zhao Assignment #1 part 2

--a.1
select catalog.cno, ctitle
from catalog, courses, enrolls,students
where catalog.cno = courses.cno
and courses.sectno = enrolls.sectno
and courses.term = enrolls.term
and enrolls.sid = students.sid
and lower(fname) = 'willie'
and lower(lname) = 'smith';

--a.2
select fname, lname
from students, enrolls, courses, catalog
where students.sid = enrolls.sid
and catalog.cno = courses.cno
and courses.sectno = enrolls.sectno
and courses.term = enrolls.term
and ctitle like 'Intro% to Programming II';

--a.3
select students.sid 
from students, enrolls
where students.sid = enrolls.sid
and enrolls.sid not in (select sid from enrolls where term = 'S17');

--a.4
select sid
from enrolls, courses
where enrolls.term = courses.term
and enrolls.sectno = courses.sectno
group by sid
having count(enrolls.sectno) = (select count(*) from catalog);

--a.5
select distinct fname, lname
from students, enrolls
where students.sid not in (select sid from enrolls);

--a.6
select fname, lname
from students, enrolls
where students.sid = enrolls.sid
group by fname,lname
having count(enrolls.sid) = (select max(count(sid)) from enrolls group by sid);

--a.7
select courses.term, courses.sectno as section_number, ctitle as course_title, count(sid)
from catalog, courses, enrolls
where catalog.cno = courses.cno
and courses.term = enrolls.term
and courses.sectno = enrolls.sectno
group by courses.term, courses.sectno, ctitle;

--a.8
select courses.term, courses.sectno, ctitle
from catalog, courses, enrolls
where catalog.cno = courses.cno
and courses.term = enrolls.term
and courses.sectno = enrolls.sectno
group by courses.term, courses.sectno, ctitle
having count(sid) >= (select avg(count(sid)) from enrolls group by term, sectno);

--a.9
select enrolls.sid, enrolls.term, enrolls.sectno, components.compname, points*weight/100 as weighted_score
from enrolls, components, scores
where enrolls.term = components.term
and components.term = scores.term
and enrolls.sectno = components.sectno
and components.sectno = scores.sectno
and enrolls.sid = scores.sid
and scores.compname = components.compname;

--a.10
select students.sid, fname, lname, sum(points*weight/100) as course_avg
from components, students, scores
where scores.sid = students.sid
and scores.term = components.term
and scores.sectno = components.sectno
and scores.compname = components.compname
and scores.term = '&Term'
and scores.sectno = '&SectionNumber'
group by students.sid, fname, lname;

--b.1
delete from students
where fname = 'Jonathan'
and lname = 'Miller';

--b.2
delete from enrolls
where sid = '4444'
and term = 'F16'
and sectno = '1031';

--b.3
update scores
set points = points + 10
where term = 'F16'
and sectno = '1031'
and compname = 'Exam1';

--b.4
insert into enrolls (sid, term, sectno) select sid,'S17','1031' from enrolls 
where term = 'F16' and sectno = '1031'
and sid not in(select sid from enrolls where term = 'S17' and sectno = '1031');

--reset the changes
--delete from enrolls where sid = '2222' and term = 'S17' and sectno = '1031';
--delete from enrolls where sid = '4444' and term = 'S17' and sectno = '1031';

--b.5
drop table tempt;
create table tempt 
as (select courses.term, courses.sectno from courses
join (select term, sectno from enrolls group by term, sectno having count(sid)<5) tempt
on courses.term = tempt.term
and courses.sectno = tempt.sectno);

delete from scores
where (term,sectno) in (select term, sectno from tempt);

delete from components
where (term,sectno) in (select term, sectno from tempt);

delete from enrolls
where (term,sectno) in (select term, sectno from tempt);

delete from courses
where (term,sectno) in (select term, sectno from tempt);
