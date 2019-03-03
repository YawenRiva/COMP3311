
create table Department (
    name        text,
    phone       text,
    location    text,
    manager     text unique not null,
    Mdate       date,
    
    primary key (name)
);

create table Employee (
    SSN         text,
    birthdate   date,
    name        text,
    WorksFor    text not null,
    foreign key (WorksFor) references Department(name),
    primary key (SSN)
);
-- alter table - add, delete, or modify columns in an existing table
alter table Department add constraint FK_constraint
    foreign key (manager) references Employee(SSN)

create table Department (
    SSN         text,
    name        text,
    birthdate   date,
    relation    text,
    primary key (SSN, name),
    foreign key (SSN) references Employee(SSN)
);

create table Project (
    Pname       text,
    Pnumber     text,
    primary key(Pname, Pnumber)
);

create table Participation (
    SSN         text,
    Pname       text,
    Pnumber     text,
    time        integer,
    foreign key (Pname) references Project(Pname),
    foreign key (Pnumber) references Project(Pnumber),
    foreign key (SSN) references Employee(SSN),
    primary key (SSN, Pname, Pnumber)
);
