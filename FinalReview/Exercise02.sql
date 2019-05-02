-- QUESTION 7
CREATE TABLE CompanyListing (
    name   char(4) primary key,
    networth   numeric(6,2), -- 一共六位数有两位是小数点后
    sharePrice numeric(20,2)
);

-- QUESTION 8
CREATE TABLE PERSON (
    familyname  varchar(50),
    firstname   varchar(50),
    initial     varchar(20),
    adnumber    integer,
    street      text,
    suburb      varchar(20),
    birthday    date,
    primary key (famlyname, firstname, initial)
);

-- QUESTION 10
CREATE TABLE SUPPLIER (
    name   varchar(50) primary key,
    city   varchar(20)
);
CREATE TABLE PART (
    number  integer primary key,
    colour  varchar(20)
);
CREATE TABLE SUPPLY (
    quantity integer,
    supplier varchar(50) references SUPPLIER(name),
    part     integer references to PART(number),
    primary key (quantity, supplier, part)
);


-- QUESTION 11
CREATE TABLE car (
    rego_num    integer primary key,
    model       varchar(40),
    year        integer
);
CREATE TABLE person (
    licence     integer primary key,
    name        varchar(20),
    address     varchar(60)
);
CREATE TABLE accident (
    report_num   integer primary key,
    location     text,
    "date"       date
);
CREATE TABLE owns (
    owner        integer references person(licence),
    car          intefer references car(rego_num)
    primary key (owner, car)
);
CREATE TABLE involves (
    report       integer references accident(report_num),
    car          integer references car(rego_num),
    person       integer references person(licence),
    damage       text, --solution said its money
    primary key (report, car, person)
);


-- QUESTION 12
CREATE TABLE team (
    name    varchar(20) primary key,
    captain varchar(30) not null references player(name)
);
CREATE TABLE player (
    name    varchar(30) primary key,
    team    varchar(20) not null references team(name)
);
CREATE TABLE fan (
    name    varchar(30) primary key
);
CREATE TABLE team_colours (
    team    varchar(20) references team(name),
    colour  text,
    primary key (team, colour)
);
CREATE TABLE favTeams (
    fan     varchar(30) references fan(name),
    team    varchar(20) references team(name),
    primary key(fan,team)
);
CREATE TABLE favPlayers (
    fan      varchar(30) references fan(name),
    player   varchar(30) references player(name),
    primary key (fan,player)
);
CREATE TABLE favColours (
    fan     varchar(30) references fan(name),
    colour  text,
    primary key (fan, colour)
);


-- QUESTION 13
CREATE TABLE truck (
    truck_no    integer primary key,
    maxwt       float,
    maxvol      float,
);
CREATE TABLE trip (
    trip_no     integer primary key,
    t_date      date,
    truck       integer references truck(truck_no)
);
CREATE TABLE store (
    name        varchar(50),
    address     varchar(50) primary key
);
CREATE TABLE warehouse (
    location    varchar(50) primary key
);
CREATE TABLE shipment (
    ship_no     integer primary key,
    volumn      float,
    weight      float,
    trip_no     integer references trip(trip_no),
    store       varchar(50) references store(address)
);
CREATE TABLE source (
    trip    integer references trip(trip_no),
    warehouse  varchar(50) referemces warehouse(location),
    location (trip,warehouse)
);


-- QUESTION 14
-- ONE TABLE REQUIRES FOREIGN KEY FROM ANOTHER TABLE WILL ADD LATER CASE
CREATE TABLE employee (
    ssn     integer primary key,
    birthday date,
    name     varchar,
    worksfor varchar(50) not null --references department(name)
);
CREATE TABLE department (
    name    varchar(50) primary key,
    phone   varchar(20),
    manager integer not null references employee(ssn)
);
alter table employee add foreign key (worksfor) references department(name);
...
