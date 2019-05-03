QUESTION 8
ER STYLE MAPPING
CREATE TABLE Employee (
	id	integer primary key,
	name	text,
	position text
);
CREATE TABLE Part_time (
	id	integer references Employee(id),
	fraction float check (fraction >= 0.0 and fraction < 1.00),
	primary key(id, fraction)
);
CREATE TABLE Casual (
	id	integer references Employee(id),
	primary key(id)
);
CREATE TABLE Hours (
	id	integer references Casual(id),
	start	time,
	end     time,
	date	time,
	primary key(id, date)
	constraint Valid check
	(end > start)
);


SINGLE TABLE STYLE MAPPING
CREATE TABLE Employee (
	id	integer primary key,
	name 	text,
	position text,
	fraction float,
	subclass text check (subclass in ('Casual','Part_time')),
	constraint Subclass check
	(
	(subclass='Casual' and fraction is null)
	or
	(subclass='Part_time' and fraction is not null)	
	)
);
CREATE TABLE Hours (
	id	integer references Employee(id),
	start	time,
	end     time,
	date	time,
	primary key(id, date),
	constraint Valid check
	(end > start)
);
