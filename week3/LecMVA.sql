create table Person (
    familyName      text not null,
    givenName       text not null,
    weight          float,
    ssn             integer,
    birthDate       date,
    primary key (ssn)
);

create table hobbies (
    Person      integer references Person(ssn),
    hobby       text,
    primary key (person, hobby)
);
