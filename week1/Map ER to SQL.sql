#1
create table Staff (
    staffID     integer,
    /*char[n] (fixed-length string data, n MUST be 1-8000bytes)
      varchar[n|max] (variable-length string data, n CAN be 1-8000bytes)*/
    name        varchar(50) not null,
    /*staff member has to have a name so "not null", unneccessary for primary key staffID "*/
    /*subject is multivalued attributes*/
    /*subjects*/
    primary key(staffID)
);
create table StaffSubjects (
    /*associated to the staff member*/
    /*staffID is an interger because its a foreign key that references to the staffID in Staff*/
    staffID     integer,
    /*variable-length non-unicode data in the code page, subject can use 'varchar', name can use text*/
    subject     text,
    foreign key (staffID) references Staff(staffID),
    primary key (staffID, subject)
);



#2
create table Students (
    stuID       integer,
    name        text not null,
    birthday    date,
    /*CHECK CONSTRAINT defined on a table must refer to only columns in that table*/
    year        integer check (year between 1 and 12),
    /*hobbies = multivalued attributes, create new table associated to the Students*/
    primary key (stuID)
);
create table StudentHobbies (
    student    integer,
    hobby      text,
    foreign key (student) references Students(stuID),
    primary key (stuID, hobby)
);


#3
/*create table for the relationships (many to many relationships)*/
create table Enrols (
    Student
    course
    primary key (student,course)
);
