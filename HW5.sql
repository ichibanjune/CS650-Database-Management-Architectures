-- Minxuan Zhao & Yiyang Shen
--CS650 Assignment 5

--2.a
select cname, street, city, zip 
from xcustomers
where cno not in (select extractvalue(o.orderr, '/order/customer') from xorders o);

--2.b
select cno, xcustomers.CNAME
from xcustomers, xorders o
where cno = extractvalue(o.orderr,'/order/customer')
and o.orderr.extract('/order/items/item/partNumber/text()').getStringVal() like '%10506%';

--2.c
select distinct cno,cname
from xorders o, xemployees, xcustomers
where extractvalue(o.orderr, '/order/takenBy') = xemployees.eno
and extractvalue(o.orderr,'/order/customer') = xcustomers.cno
and xemployees.city = 'Wichita';

--2.d
select distinct cno,cname
from xorders o, xemployees, xcustomers
where extractvalue(o.orderr, '/order/takenBy') = xemployees.eno
and extractvalue(o.orderr,'/order/customer') = xcustomers.cno
and extractvalue(o.orderr, '/order/takenBy') in 
    (select eno from xemployees where city = 'Wichita')
and cno not in(
    select distinct cno
    from xorders o, xemployees, xcustomers
    where extractvalue(o.orderr, '/order/takenBy') = xemployees.eno
    and extractvalue(o.orderr,'/order/customer') = xcustomers.cno
    and extractvalue(o.orderr, '/order/takenBy') in 
        (select eno from xemployees where city != 'Wichita'));
        
--2.e
select distinct eno, ename 
from xemployees
where eno not in (select extractvalue(o.orderr, '/order/takenBy') from xorders o);














