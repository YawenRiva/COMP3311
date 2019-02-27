-- Simple database of Staff/Student/Course/Enrolment data

-- Table of data about academic staff
-- e.g. ('jas','John Shepherd','Senior Lecturer',56494)

create table Staff (
	userid      varchar(10),
	name        varchar(30),
	position    varchar(20),
	phone       integer,
	primary key (userid)
);

insert into Staff values ('jingling','Jingling Xue','Professor',54889);
insert into Staff values ('jas','John Shepherd','Senior Lecturer',56494);
insert into Staff values ('andrewt','Andrew Taylor','Senior Lecturer',55525);


-- Table of data about students
-- e.g. ('adsp123','Adam Spencer',3645,'01-Mar-2002')

create table Students (
	userid      varchar(10),
	name        varchar(30),
	degree      integer,
	commenced   date,
	primary key (userid)
);

insert into Students values ('adsp123','Adam Spencer',3645,'01-Mar-2002');
insert into Students values ('wism987','Will Smith',3978,'01-Mar-2002');
insert into Students values ('joys864','Joy Susanto',3649,'03-Mar-2003');
insert into Students values ('anbe323','Andrew Betts',3978,'01-Mar-2002');
insert into Students values ('sueo323','Sue Ong',3645,'01-Mar-2002');
insert into Students values ('prad963','Pradeep Roy',3649,'03-Mar-2003');


-- Table of data about courses
-- e.g. ('COMP3311','Database Systems','jas',340)

create table Courses (
	code        char(8),
	title       varchar(50),
	lecturer    varchar(10),
	quota       integer,
	primary key (code),
	foreign key (lecturer) references Staff(userid)
);

insert into Courses values ('COMP2041','Software Construction','andrewt',999);
insert into Courses values ('COMP3131','Programming Languages & Compilers','jingling',250);
insert into Courses values ('COMP3311','Database Systems','jas',340);


-- Table of data about student enrolment in courses
-- e.g. ('COMP3311','adsp123',75.0)

create table Enrolment (
	course      char(8),
	student     varchar(10),
	mark        real check (mark >= 0 and mark <= 100),
	primary key (course,student),
	foreign key (course) references Courses(code),
	foreign key (student) references Students(userid)
);

insert into Enrolment values ('COMP2041','joys864',76.7);
insert into Enrolment values ('COMP2041','prad963',64.5);
insert into Enrolment values ('COMP3131','anbe323',79.4);
insert into Enrolment values ('COMP3131','sueo323',93.1);
insert into Enrolment values ('COMP3131','wism987',51.2);
insert into Enrolment values ('COMP3311','adsp123',75.0);
insert into Enrolment values ('COMP3311','prad963',44.7);
insert into Enrolment values ('COMP3311','sueo323',95.9);
insert into Enrolment values ('COMP3311','wism987',45.0);

