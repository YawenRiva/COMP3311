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
      foreign key (StuID) references to STUDENT(StuID),
      Primary key (StuID, hobbies)
 );
