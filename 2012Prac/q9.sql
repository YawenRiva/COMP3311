CREATE TRIGGER AddCourseEnrolmentTrigger
               after insert on CourseEnrolments
               execute procedure fixCoursesOnAddCourseEnrolment();
-- As its insert only consider the new value
CREATE OR REPLACE FUNCTION fixCoursesOnAddCourseEnrolment() RETURNS TRIGGER
AS $$
DECLARE
    _ns integer; _ne integer; _sum integer; _avgeval float;
BEGIN
-- we consider the avgeval only if (nS > 10 && (3*nE) > nS)
    -- get the value from the current course table
    select ns, ne, avgeval into _ns, _ne, _avgeval
    from courses where courses.id = new.courses;

    -- consider the number of student
    _ns := _ns + 1;
    -- consider the number of evaluation
    -- the student might not rate the course
    if (new.stueval is not null) then
        _ne := _ne + 1;

        if (_ns > 10 && (3*_ne) > _ns) then
        -- one more rating then need to calculate the avgeval again
            select sum(stueval) into _sum
            from CourseEnrolments where course = new.course;
            _sum := _sum + new.stueval;
            _avgeval := _sum/_ne;
        else
            _avgeval := null;
        end if;
    end if;
    UPDATE  courses
    SET     avgeval=_avgeval, ns=_ns, ne=_ne
    where   courses.id = new.course;
END;
$$ language plpgsql;



create trigger DropCourseEnrolmentTrigger
after delete on CourseEnrolments
execute procedure fixCoursesOnDropCourseEnrolment();
-- delete, the only old value considered
create or replace function fixCoursesOnDropCourseEnrolment() returns trigger
as $$
DECLARE
    _ns integer; _ne integer; _avgeval float; _sum integer;
BEGIN
    select ns, ne, avgeval into _ns, _ne, _avgeval
    from courses where courses.id = old.course;
    -- update number of student
    _ns := _ns - 1;
    -- if he evaluated the course then need to delelete 1
    if (old.stueval is not null) then
        _ne := _ne - 1;
        if (_ns > 10 && (3*_ne) > _ns) then
            select sum(stueval) into _sum
            from CourseEnrolments where course=old.course;
            _sum := _sum - old.stueval;
            _avgeval := _sum/_ne;
        else
            _avgeval := null;
        end if;
    end if;
    UPDATE  courses
    SET     ne=_ne, ns=_ns, avgeval=_avgeval
    WHERE   courses.id = old.course;
end;
$$ language plpgsql;


create trigger ModCourseEnrolmentTrigger
after update on CourseEnrolments
execute procedure fixCoursesOnModCourseEnrolment();

create or replace function fixCoursesOnModCourseEnrolment() returns trigger
as $$
declare
     _ns integer; _ne integer; _avgeval float; _sum integer;
BEGIN
    select ne, ns, avgeval into _ne, _ns, _avgeval
    from courses where courses.id = old.id;
    if (new.stueval is not null and old.stueval is null) then  
        _ne := _ne + 1;
    end if;
    if (new.stueval <> old.stueval) then
        select sum(stuEval) into _sum
        from CourseEnrolments where course=old.course;
        _sum := (_sum - old.stueval + new.stueval);
        _avgeval := _sum / _ne;
    end if;
    UPDATE  courses
    SET     ne=_ne, ns=_ns, avgeval=_avgeval
    WHERE   courses.id = old.course;
end;
$$ language plpgsql;
