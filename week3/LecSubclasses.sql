-- DISJOINT STRUCTURE
-- TOTAL - STUDENT HAS TO BE EXACT ONE OF THE FOLLOWING SUBCLASSES
create table Student (
    sid         integer primary key,
    name        text not null,
    address     text not null,
    degree      text,
    major       text,
    thesis      text,
    constraint DisjointTotal check (
        (degree is not null and major is null and thesis is null)
        or
        (degree is null and major is not null and thesis is null)
        or
        (degree is null and major is null and thesis is not null)
    )
    -- if its partial which means it has to be zero of exact one of the subclasses
    -- add one more constaint
    -- degree is null and major is null and thesis is null
);

-- OVERLAPPING STRUCTURE
-- TOTAL - STUDENT TO BE ONE OF MORE OF THE FOLLOWING SUBCLASSES
create table Student (
    sid         integer primary key,
    name        text not null,
    address     text not null,
    degree      text,
    major       text,
    thesis      text,
    constraint OverlappingTotal check (
        degree is not null
        or 
        major is not null
        or 
        thesis is not null
    )
    -- if its partial instead of total
    -- each student belongs to zero or more subclasses
    -- then it doesnt need the constraint
);



-- #1 ER MAPPING
create table Student (
    sid         integer,
    name        varchar(100) not null,
    address     text not null,
    primary key (sid)
);
create table Undergrad (
    student     integer references Student(sid),
    degree      text,
    primary key (student)
);
create table Master (
    student     integer references Student(sid),
    major       text,
    primary key (student)
);
create table Research (
    student     integer references Student(sid),
    thesis      text,
    primary key (student)
);

-- #2 OO-MAPPING 
-- include student information in each of the three different degrees
