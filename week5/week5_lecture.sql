TRIGGER EXAMPLE 1
-- Consider a database of people in the USA
create table Person (
    id      integer primary key,
    ssn     varchar(11) unique,
    -- eg. family given, street...
    state   char(2)
);
create table States (
    id      integer primary key,
    code    char(2) unique,
    -- ... name, area, population, flag...
);

-- 1. ensure that only valid state codes are used
create trigger checkState
before INSERT or UPDATE on Person
for each row execute procedure checkState();

create function checkState() returns trigger
as $$
begin
    -- remove the spaces and convert all of them into uppercase
    new.state = upper(trim(new.state));
    -- !~ is does not match case sensitive 'thomas' !~ '*.thomas*'
    if (new.state !~ '^[A-Z][A-Z]$') then
        raise exception 'Code must be two alpha chars';
    end if;
    -- implement referential integrity check
    select * from State where code=new.state;
    if (not found) then
        raise exception 'Invalid code %', new.state;
    end if;
    return new;
end;
$$ language plpgsql





TRIGGER EXAMPLE 2
-- department salary totals
employee (id, name, address, dept, salary, ..)
department (id, name, manager, totsal, ...)
-- assertion that we wish to maintain
create assertion TotalSalary check (
    not exist (
        select d.id from department d
        where d.totsal <> (select sum(e.salary) from employee e
                           where e.dept = d.id)
    )
);
-- a new employee starts work in some department
create trigger newarrive AFTER INSERT on Employee
for each row execute procedure newarrive();

create function newarrive() returns trigger
as $$
begin
    if (new.dept if not null) then
        UPDATE department
        SET    totsal = totsal + new.salary
        where  department.id = new.depl
    end if;
    return new;
end; $$ language plpgsql;

-- an employee gets a rise in salary
-- an employee changes from one department to another
create trigger raisedsalry AFTER UPDATE on Employee
for each row execute procedure raisedsalary();

create function raisedsalary() returns trigger
as $$
begin
    UPDATE department
    SET    totsal = totsal + new.salary
    where  department.id = new.dept;
    UPDATE department
    SET    totsal = totsal - old.salary
    where  department.id = new.dept;
    return new;
end; $$ language plpgsql
-- an employee leaves the company
create trigger employeeleave after DELETE on Employee
for each row execute procedure employeeleave();

create function employeeleave() returns trigger
as $$
begin
    if (old.dept is not null) then
        UPDATE  department
        SET     totsal = totsal - old.salary
        where   department.id = old.dept;
    end if;
    return old;
end; $$ language plpgsql;
