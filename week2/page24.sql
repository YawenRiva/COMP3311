-- PAGE 24 EXERCISE

-- account numbers must look like A-306
create domain AccNumType as 
    text check (value ~ '[A-Z]-[0-9]{3}'),

create table Account (
    AccountNo   AccNumType,
    -- AccountNo text check (accountNo ~ '^[A-Z]-[0-9]{3}$')
    -- no account can be overdrawn
    balance     float check (balance >= 0),
    foreign key (branchName) references Branch(branchName),
    primary key (AccountNo)
);

create table Branch (
    branchName  text,
    address     text not null,
    assets      integer,
    primary key (branchName)
);

-- customer numbers are 7-digit integers
-- char(7) -> stable 7 digit
-- value ~ '[0-9]{7}' 7 digit each digits constraint is 0-9
create domain CustNumType as 
    char(7) check (value ~'[0-9]{7}');

create table Customer (
    -- domain constraints
    customerNo  CustNumType,
    name        text not null,
    address     text unique not null,
    homeBranch  text,
    primary key (customerNo),
    foreign key (homeBranch) references Branch(branchName)
);

create table HeldBy (
    account     AccNumType,
    customer    CustNumType,
    primary key (account, customer)
    foreign key (account) references Account(AccountNo),
    foreign key (customer) references Customer(customerNo)
);
