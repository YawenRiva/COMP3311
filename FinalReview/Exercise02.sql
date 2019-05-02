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
