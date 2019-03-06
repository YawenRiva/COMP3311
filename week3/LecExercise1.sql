
-- or we can use the domain for all the name values
-- create domain NameValue as varchar(100) not null
-- because non of the name are primary key but they cant be null

create table Drug (
    dno         text,
    -- the name for each drug needs to be unique
    -- or we can say
    -- name     NameValue unique
    name        text unique not null,
    formula     text,
    primary key (dno)
);

create table Doctor (
    tfn         text,
    name        text not null,
    specialty   text not null,
    primary key (tfn)
);

create table Patient (
    pid         text,
    name        text not null,
    address     text not null,
    primary key (pid)
);

create table Prescribes (
    quantity    integer not null,
    Pdate       date,
    doctor      text,
    patient     text,
    drug        text,
    foreign key (doctor) not null references to Doctor(tfn),
    foreign key (patient) references to Patient(pid),
    foreign key (drug) references to Drug(dno),
    primary key (Pdate, doctor, patient, drug)
);
-- because the prescribe needs to include the date as part of the information
-- doctor information can include or not in the primary key
-- because doctor gives patient prescribtion
-- so the prescribs include patient, drug infos and the date
