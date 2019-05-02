--EXAMPLE 1
--(STAFF HAS STAFFID(UNIQUE) NAME AND SEVERAL SUBJECTS)
 CREATE TABLE STAFF (
    staffID   integer,
    name      varchar(50) not null,    
    peimary key (staffID)
 );
-- subject is multi-valued attribute, its kind of like a relationship between staff and subjects
 CREATE TABLE SUBJECTS (
    staffID   integer,
    subject   text,
    foreign key (staffID) references STAFF(staffID),
    primary key(staffID, subject)
 );
 
 --EXAMPLE 2
 --(STUDENT HAS STUID(UNIQUE), NAME, BIRTHDAY, MULTI-VALUED HOBBIES, YEAR)
 CREATE TABLE STUDENT (
      StuID    integer,
      name     varchar(50),
      birthday date,
      year     integer check (year between 1 and 12)
      primary key(StuID)
 );
 CREATE TABLE HOBBIES (
      StuID     integer,
      hobbies   text,
      foreign key (StuID) references STUDENT(StuID),
      Primary key (StuID, hobbies)
 );


--EXAMPLE 3
--STUDENT ENROLS IN CLASS MANY TO MANY
CREATE TABLE ENROLS (
     student    integer,
     course     integer,
     foreign key (student) references Students(id),
     foreign key (courses) references Course(id),
     primary key (student, course)
);

--EXAMPLE 4
--COURSE HAS ONE CONVENOR WHO IS A STAFF MEMBER one(tp)->one
CREATE TABLE COURSE (
     id    integer primary key,
     ...
     convenor integer not null references STAFF(id),
);

--EXAMPLE 5
-- ONE STAFF MANAGES ONE BRANCH, BRANCH HAS TO HAVE A MANAGER
CREATE TABLE BRANCH (
     id    integer primary key,
     ...
     manager  integer not nullreferences STAFF(id)
);
CREATE TABLE STAFF (
    id    integer primary key,
    ...
    manages    integer not null references BRANCH(id)
);
