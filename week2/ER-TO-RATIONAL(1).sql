

create table store (
    phone   integer,
    address text,
    primary key (phone)
);

create table customer (
    custNo  integer,
    name    text,
    address text,
    hasFav  integer,
    primary key (custNo),
    foreign key (hasFav) references store(phone)
);

create table Account (
    acctNo  integer,
    balance integer not null,
    UseAt   integer,
    primary key(acctNo),
    foreign key (UseAt) references store(phone)
);

create table has (
    custNo  integer,
    acctNo  integer,
    primary key(custNo, acctNo),
    foreign key (custNo) references customer(custNo),
    foreign key (acctNo) references Account(acctNo)
);