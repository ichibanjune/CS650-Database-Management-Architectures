--1
--firstphone function is designed to show the primary phone of any selected customer
create or replace function firstphone(input_varray phones_varray_type)
return char
is
    v_elem char(12);
begin
    v_elem :=input_varray(1);
    return v_elem;
end;
/

set serveroutput on
set verify off
--The procedure invoicereport produces an invoice report from a take-in order number
create or replace procedure invoicereport (inputorder in o_orders.ono%type)
as
c_name VARCHAR2(30);
c_no o_customers.cno%type;
c_str VARCHAR2(30);
c_city VARCHAR2(30);
c_zip number(5);
c_phone char(12);

a_ono o_orders.ono%type;

a_emp VARCHAR2(30);
a_empno o_employees.eno%type;
a_receive date;
a_ship date;

cur_ono o_orders.ono%type;
a_pno o_parts.pno%type;
a_pname o_parts.pname%type;
a_pqty NUMBER(38) ;
a_price o_parts.price%type;
a_ext o_parts.price%type;
a_total o_parts.price%type;

cursor orderparts is   
    select o.ono, p.pno, p.pname, od.qty, p.price, od.qty*p.price
    from o_orders o, o_parts p, table(o.odetails) od
    where od.pno = p.pno;

begin
    a_ono := inputorder;
    a_total := 0;
    select c.person.name, c.cno, c.person.address.street, c.person.address.city, 
       c.person.address.zip, firstphone(c.person.phones),
       e.person.name, o.eno, o.received, o.shipped
    into c_name, c_no, c_str, c_city, c_zip, c_phone,a_emp, a_empno, a_receive, a_ship
    from o_customers c, o_employees e, o_orders o
    where o.cno = c.cno
    and o.eno = e.eno
    and o.ono = a_ono;
    dbms_output.put_line('Customer: '||c_name||'    Customer Number: '||c_no);
    dbms_output.put_line('Street: '||c_str);
    dbms_output.put_line('City: '||c_city);
    dbms_output.put_line('Zip: '||c_zip);
    dbms_output.put_line('Phone: '||c_phone);
    dbms_output.put_line('---------------------------------------------------------------');
    dbms_output.put_line('Order Number: '||a_ono);
    dbms_output.put_line('Taken by: '||a_emp||'('||a_empno||')');
    dbms_output.put_line('Received on: '||a_receive);
    dbms_output.put_line('Shipped on: '||a_ship);
    dbms_output.put_line('              ');
    dbms_output.put_line(rpad('Part No.',10)||rpad('Part Name',30)||rpad('Quan',9)||rpad('Price',9)||rpad('Ext',9));
    dbms_output.put_line('---------------------------------------------------------------');

    open orderparts;
    loop
        fetch orderparts into cur_ono, a_pno, a_pname, a_pqty, a_price, a_ext;
            if cur_ono = a_ono
                then dbms_output.put_line(rpad(a_pno,10)||rpad(a_pname,30)||rpad(a_pqty,9)||rpad(a_price,9)||rpad(a_ext,9));
                    a_total := a_total + a_ext; 
            end if;
        exit when orderparts%notfound;
    end loop;
    close orderparts;
    dbms_output.put_line('---------------------------------------------------------------');
    dbms_output.put_line('                                           Total:        '||a_total);
    dbms_output.put_line('---------------------------------------------------------------');
end;
/

--test code
--begin
--invoicereport(1020);
--end;
--/

--2
set serveroutput on
set verify off
declare
cname o_customers.person.name%type;
cstr o_customers.person.address.street%type;
ccity o_customers.person.address.city%type;
cstate o_customers.person.address.state%type;
czip o_customers.person.address.zip%type;
cphone char(12);
cur_customer sys_refcursor;

begin
    open cur_customer for 
        select distinct c.person.name, c.person.address.street, c.person.address.city, 
        c.person.address.state, c.person.address.zip
        from o_customers c, table(c.person.phones) cph
        where cph.column_value like '&AreaCode%';
    
    dbms_output.put_line(rpad('Customer',15)||'Address');
    dbms_output.put_line('------------------------------------------------');
    loop
    fetch cur_customer into cname, cstr, ccity, cstate, czip;
    exit when cur_customer%notfound;
    dbms_output.put_line(rpad(cname,15) ||cstr||' '||ccity||' '||cstate||' '||czip||' ');
    end loop;
    
    close cur_customer;
end;
/



--3
set serveroutput on
set verify off
declare
a_ono number(5);
a_pno number(5);
a_qty number(38);
t_qty number(38);  --total quantity of the part ordered

    cursor cur_odetail is
        select o.ono, od.pno, od.qty
        from o_orders o, table(o.odetails) od; 
begin
    dbms_output.put_line('Order No.   Part No.   Part Qty');
    dbms_output.put_line('------------------------------------');
    t_qty := 0;
    open cur_odetail;
    loop
        fetch cur_odetail into a_ono,a_pno, a_qty;
        if a_pno = '&Pno'
            then dbms_output.put_line(a_ono||'        '|| a_pno||'         '|| a_qty);
                 t_qty := t_qty + a_qty;
        end if;
        exit when cur_odetail%notfound;
    end loop;
    dbms_output.put_line('------------------------------------');
    dbms_output.put_line('The total quantity of the part ordered is ' ||t_qty);
    close cur_odetail;
end;
/