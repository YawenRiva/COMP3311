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
