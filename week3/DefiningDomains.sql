-- positive integer
create domain Positive_integer as
    integer check (value > 0);
    
-- a person's age
create domain Person_age as
    integer check(value > 0 and value <= 150)
    
-- a UNSW course code
create domain UNSW_course as
    char(8) check (value ~ '[A-Z]{4}[1-9]{4}');
    
-- a UNSW student/staff ID
create domain UNSW_id as
    char(8) check (value ~ 'z[1-9]{7}');
    
-- colours (as used in HTML/CSS)
-- eg. gold(#FFD700), orange(#FFA500)
create domain Colour as
    char(7) check (value ~ '#[0-9,A-F]{6}');
  
-- pairs of integers (x,y)
create domain Pair_integers as
    (x integer, y integer);
    
-- standard UNSW grades(FL,PS,CR,DN,HD)
create domain UNSW_grades as
    char(2) check (value in ('FL','PS','CR','DN','HD');

                   
                   
                   
                   
create type UnswGradesType as
	enum ('FL','PS','CR','DN','HD');
	-- FL < PS < CR < DN < HD

create table UnswGrades (
	id      integer,
	name    char(2),
	low     float,
	high    float,
	primary key (id)
);

insert into UnswGrades values (1,'FL', 0.0, 49.9);
insert into UnswGrades values (2,'PS', 50.0, 64.9);
insert into UnswGrades values (3,'CR', 65.0, 74.9);
insert into UnswGrades values (4,'DN', 75.0, 84.9);
insert into UnswGrades values (5,'HD', 85.0, 100.0);
