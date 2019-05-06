2. consider a schema that represents information about a university
Student (id, name, major, stage, age) -> primary key (id)
Class (name, meetsAt, room, lecturer) -> primary key (name)
Enrolled (student, class, mark) -> primary key (student, class)
Lecturer (id, name, department) -> primary key (id)
Department (id, name) -> primary key (id)

--a. find the names of all first-year(stage 1) students who are enrolled in a class taughtby Andrew Taylor.
select s.name
from student s, class c, enrolled e, lecturer l
where s.id=e.student and e.class=c.name and l.id=c.lecturer
      and l.name='Andrew Taylor' and s.stage=1;
      
--b. Find the age of the oldest student enrolled in any of John Shepherd's classes.
select max(age) from student 
where id in
(
    select student
    from  Class C, Enrolled E, Lecturer L
    where E.class = C.name and C.lecturer = L.id and L.name = 'John Shepherd'
);

--c. Find the names of all classes that have more than 100 students enrolled.
select c.name
from class c, enrolled e
where c.name=e.class and count(e.student)>=100
group by e.class;

--d. Find the names of all students who are enrolled in two classes that meet at the same time.
select name
from student
where id in (
select e1.student
from enrolled e1, enrolled e2, class c1, class c2
where e1.student=e1.student and s1.class!=e2.class and e1.class=c1.name and e2.class=c2.name
      and c1.meetsat=c2.meetsat
);

--e. Find the names of faculty members for whom the combined enrollment of the courses they teach is less than five.
select l.name
from lecturer l, department d, class c
where l.id=c.lecturer and d.id=l.department
group by c.class
having count(*)<5;

--f. for each stage, print the stage and average age of students
select stage, avg(age)
from student
group by stage;

--g. find the names of students who are not enrolled in any class
select name from student where id is not in
(select student from enrolled);
