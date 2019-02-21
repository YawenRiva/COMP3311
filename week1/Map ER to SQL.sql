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
/*create table for the relationships */
#3.1
/*student enrols in course (many to many relationships)*/
/*if its many to many relationship, create table for relationship directly*/
create table Enrols (
    /*relationship table contains related entities (with the foreign keys)*/
    Student     integer references Student(id),
    course      integer references Course(id)
    primary key (student,course)
);

#3.2
/*course convenor staff (many to one relationship)*/
/*each course has a convenor which is a staff member*/
/*many to one relationship, create table for MANY side entities
  which contains the relationship with the other side
  *** set RELATIONSHIP as ATTRIBUTES with related foreign keys
  if partial relationship contains, add 'not null' for certain side*/
create table Courses (
    id      integer,
    /*..title..*/
    /*must has at least one staff member so 'not null'*/
    convenor integer not null references to Staff(id)
    /*foreign key for the relationship*/
    primary key (id)
);

#3.3
/*one to one relationship
  Staff manages branch
  Each branch must have be managed by one staff, not every staff needs to be manager
  ***show the aspect from two sides***
*/
create table Staff (
    id      integer primary key,
    /*if not a manager the manages can be null*/
    manages integer references Branches(id)
    -- optional
);
create table Branches (
    id      integer primary key,
    /*as each branch must managed by ONE manager so not null*/
    manages integer not null references Staff(id)
);

#3.4
/* many to many relationship with total participate
   student enrols in Courses
   each student must enrols in courses
*/

-- no design can deal with this type of ER relationship
