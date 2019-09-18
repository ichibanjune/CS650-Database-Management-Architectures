--Minxuan Zhao
--CS650 Assignment 2
--2/21/2018

--1

create or replace procedure beststudents
as
cursor c is
    select courses.cno as cno, courses.sectno as sectno, courses.term as term, catalog.ctitle as ctitle, students.sid as sid, 
           students.fname|| ' ' || students.lname as name, finalscore
        from courses, catalog, students,
            (select a.sid, a.term, a.sectno, finalscore 
            from (select sid, term, sectno, sum(weighted_score) as finalscore
                from (select enrolls.sid, enrolls.term, enrolls.sectno, components.compname, points, maxpoints, weight, points*weight/maxpoints as weighted_score
                    from enrolls, components, scores
                    where enrolls.term = components.term
                    and components.term = scores.term
                    and enrolls.sectno = components.sectno
                    and components.sectno = scores.sectno
                    and enrolls.sid = scores.sid
                    and scores.compname = components.compname)
                group by sid, term, sectno
                order by term, sectno) a
                inner join 
                (select term, sectno, max(finalscore) as overall
                    from (select sid, term, sectno, sum(weighted_score) as finalscore
                        from (select enrolls.sid, enrolls.term, enrolls.sectno, components.compname, points, maxpoints, weight, points*weight/maxpoints as weighted_score
                        from enrolls, components, scores
                        where enrolls.term = components.term
                        and components.term = scores.term
                        and enrolls.sectno = components.sectno
                        and components.sectno = scores.sectno
                        and enrolls.sid = scores.sid
                        and scores.compname = components.compname)
                        group by sid, term, sectno
                        order by term, sectno)
                    group by term, sectno) b on
                    a.term = b.term and a.sectno = b.sectno and a.finalscore = b.overall) temp 
        where catalog.cno = courses.cno
            and courses.term = temp.term
            and courses.sectno = temp.sectno
            and students.sid = temp.sid
        order by cno, sectno, term;  
rec c%rowtype;
begin
for rec in c loop
dbms_output.put_line(rec.cno ||' '|| rec.sectno ||' '|| 
                    rec.term ||' '|| rec.ctitle ||' '|| 
                    rec.sid ||' '|| rec.name ||' '|| rec.finalscore);
end loop;
end;
/

set serveroutput on;

begin
beststudents;
end;
/

--2
create table grade_updates (
  compname varchar2(15) not null,
  sid      varchar2(5) not null,
  change   number(4,0),
  primary key (compname, sid));

create or replace procedure updatescores(inputterm varchar2, inputsectno varchar2)
is
cursor c 
is
select * from grade_updates;
rec c%rowtype;
t_num number;
sec_num number;
comp_num number;
temp number;
new_points scores.points%type;
max_points components.maxpoints%type;
begin
select count(term) into t_num from scores where term = inputterm;
select count(sectno) into sec_num from scores where sectno = inputsectno;
if t_num != 0 and sec_num != 0 then
    for rec in c loop
        select count(compname) into comp_num from scores 
        where sid = rec.sid and compname = rec.compname 
        and term = inputterm and sectno = inputsectno;
        select count(sid) into temp from scores
        where sid = rec.sid and term = inputterm and sectno = inputsectno;
        if temp !=0 then
            if comp_num !=0 then
                select scores.points + rec.change into new_points from scores 
                where scores.compname = rec.compname and scores.sid = rec.sid 
                and term = inputterm and sectno = inputsectno;
                select maxpoints into max_points from components 
                where compname = rec.compname and term = inputterm and sectno = inputsectno;
                if (new_points <= max_points and new_points >= 0) then
                    update scores set points = new_points 
                    where scores.compname = rec.compname and scores.sid = rec.sid 
                    and term = inputterm and sectno = inputsectno;
                else
                dbms_output.put_line('Error: Updated score is outside the range of allowed values!');
                end if;
            else
                dbms_output.put_line('Error: The component: "' || rec.compname || '" is invalid for student:"' || rec.sid || '"!');
            end if;
        else 
        dbms_output.put_line('Error: Student:"' || rec.sid ||'" is not in section:"' || inputsectno ||'" in "' || inputterm ||'"!');
        end if;
    end loop;
end if;
end;
/

begin
updatescores('S17', '1031');
end;
/

--3
drop table deleted_scores;
create global temporary table deleted_scores (
    t_sid VARCHAR2(5 BYTE) not null,
    t_term VARCHAR2(10 BYTE) not null,
    t_sectno NUMBER(4,0)not null,
    t_compname VARCHAR2(15 BYTE),
    t_points NUMBER(4,0))
    on commit PRESERVE rows;    

create or replace trigger score_delete
before delete on enrolls
for each row
declare
a scores.compname%type;
b scores.points%type;
begin
insert into deleted_scores values (:old.sid, :old.term, :old.sectno, a, b);
delete from scores
where sid = :old.sid
and term = :old.term
and sectno = :old.sectno;
end;
/



