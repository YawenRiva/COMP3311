
/*
for the TFN and ISBN
can do a domain check
1. Create domain TFN_type as char(11) check (value ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$');
2. Create domain ISBN_type as char(15) check (value ~ '^[A-Z][0-9]{3}-[0-9]{4}-[0-9]{5}$');

and can use the domains directly as the types such that:
TFN   TFN_type
ISBN  ISBN_type
*/

-- ER-Style mapping
Create table Person (
  TFN     integer,
  Name    varchar(30),
  Address varchar(100),
  primary key(TFN)
);
Create table Author (
  TFN     integer references Person(TFN),
  PenName varchar(30),
  primary key (TFN),
);
Create table Publisher (
  ABN     integer,
  Name    varchar(100),
  address text,
  primary key (ABN)
);
Create table Editor (
  TFN     integer references Person(TFN),
  Workfor integer not null references Publisher(ABN),
  primary key (TFN)
);
Create table Book (
  ISBN    varchar(20),
  Title   varchar(40),
  Edition varchar(20),
  editor  integer not null references Editor(TFN),
  Publisher integer not null references Publisher(ABN),
  primary key (ISBN)
);
Create table Writes (
  Author   integer references Author(TFN),
  Book     varchar(20) references Book(ISBN),
  primary key (Author, Book)
);



-- single-table-with-nulls mapping of subclasses
Create domain TFN_type as char(11) check (value ~ '^[0-9]{3}-[0-9]{3}-[0-9]{3}$')
Create domain ABN_type as char(15) check (value ~ '^[A-Z][0-9]{3}-[0-9]{4}-[0-9]{5}$')
Create table Person (
    TFN   TFN_type primary key,
    Name  varchar(30),
    Addr  varchar(50),
    penName varchar(30),
    subclass text check (subclass in ('Author','Editor')),
    Constraint Sub_checking check
    (
    (subclass='Author' and penName is not null)
    or
    (subclass='Editor' and penName is null)
    )   
);
Create table Publisher (
    ABN   ABN_type,
    Name  varchar(50),
    addr  text,
    primary key (ABN)
);
Create table Book (
    ISBN  varchar(40),
    Title varchar(40),
    Edition varchar(20),
    Editor TFN_type references Person(TFN),
    Publisher ABN_type references Publisher(ABN),
    primary key (ISBN)
);
Create table Writes (
    Author  TFN_type references Person(TFN),
    Book    varchar(40) references Book(ISBN),
    primary key(Author,Book)
);
                         
                         
                         
