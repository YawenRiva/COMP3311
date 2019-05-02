create table Employees (
      eid       integer,
      ename     varchar(30),
      age       integer,
      salary    real,
      primary key (eid)
);
create table Departments (
      did       integer,
      dname     varchar(20),
      budget    real,
      manager   integer,
      primary key (did),
      foreign key (manager) references Employees(eid)
);
create table WorksIn (
      eid       integer,
      did       integer,
      pct_time  real,
      primary key (eid,did),
      foreign key (eid) references Employees(eid),
      foreign key (did) references Departments(did)
);


-- QUESTION 1
-- YES, the order of the table declarations matters, because of the foreign key use,
-- if its not in the right order, need to do a (alter table xxx add foreign key(xxx) references xxx(xxx))

-- QUESTION 2
-- cut salary 20% young people under 25
UPDATE EMPLOYEES
SET    SALARY = SALARY * (1-0.2)
WHERE  AGE < 25；

-- QUESTION 3
-- 10% pay rise for the SALES department people
UPDATE EMPLOYEES
SET    SALARY = SALARY * (1+0.1)
WHERE  EID in -- list of sales department eid 
      (select w.eid from departments d, worksin w
       where d.dname = 'sales' and d.did = w.did);
   
-- QUESTION 4
-- Add a constraint to the CREATE TABLE statements above to ensure that every department must have a manager.
create table Departments (
      did       integer,
      dname     varchar(20),
      budget    real,
      manager   integer not null,
      primary key (did),
      foreign key (manager) references Employees(eid)
);

-- QUESTION 5
-- Add a constraint to the CREATE TABLE statements above to ensure that no-one is paid less than the minimum wage of $15,000.
create table Employees (
      eid       integer,
      ename     varchar(30),
      age       integer,
      salary    real check (salary >= 15000),
      primary key (eid)
);

-- QUESTION 6
-- Add a constraint to the CREATE TABLE statements above to ensure that no employee can be committed for more than 100% of his/her time. Note that the SQL standard allows queries to be used in constraints, even though DBMSs don't implement this (for performance reasons).
create table WorksIn (
      eid       integer,
      did       integer,
      pct_time  real,
      primary key (eid,did),
      foreign key (eid) references Employees(eid),
      foreign key (did) references Departments(did)
      constrint maxTimeCheck
                  check (
                  (select sum(w.pct_time) from worksin w where w.eid = eid) <= 1.00
                  )
);

-- QUESTION 7
-- Add a constraint to the CREATE TABLE statements above to ensure that a manager works 100% of the time in the department that he/she manages. Note that the SQL standard allows queries to be used in constraints, even though DBMSs don't implement this (for performance reasons).
create table Departments (
      did       integer,
      dname     varchar(20),
      budget    real,
      manager   integer,
      primary key (did),
      foreign key (manager) references Employees(eid)
      CONSTRAINT ManagerTime check 
      (
      (select sum(w.pct_time) from worksin w where manager = w.eid) = 1.00
      )
);

-- QUESTION 8
-- When an employee is removed from the database, it makes sense to also delete all of the records that show which departments he/she works for. Modify the CREATE TABLE statements above to ensure that this occurs.
create table WorksIn (
      eid       integer,
      did       integer,
      pct_time  real,
      primary key (eid,did),
      foreign key (eid) references Employees(eid) on delete cascade,
      foreign key (did) references Departments(did)
);


-- QUESTION 9
-- When a manager leaves the company, there may be a period before a new manager is appointed for a department. Modify the CREATE TABLE statements above to allow for this.
UPDATE DEPARTMENT
SET MANAGER = SOMEEID
WHERE DID = OURDEPID;


-- QUESTION 13
insert into R values (1,'a');
insert into S values ('a',1);

CORRECT
insert into R values (1,null);
insert into S values ('a',1);
update R set y = 'a' where x = 1;
update S set x = 1 where y = 'a';

-- question 14
create table R (
        x       integer,
        y       char(1) not null,
	primary key (x)
);
create table S (
        y       char(1),
        x       integer not null,
	primary key (y)
);
alter table R add foreign key (y) references S(y) deferrable;
alter table S add foreign key (x) references R(x) deferrable;
-- DEFERRABLE change/update after commit action

