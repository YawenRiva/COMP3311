
create domain NameValue as varchar(100) not null;

create table Drug (
    dno         text,
    Name        NameValue unique,
    formula     text,
    primary key (dno)
);

create table Doctor (
    tfn         text,
    Name        NameValue,
    specialty   text not null,
    primary key (tfn)
);

create table Patient (
    pid         text,
    Name        NameValue,
    address     text not null,
    primary key (pid)
);

create table Prescription (
    prNo        text,
    Pdate       date not null,
    forPatient  text not null references Patient(pid),
    doctorWrite text not null references Doctor(tfn),
    primary key (prNo)
);

create table includes (
    quantity    integer check (quantity > 0),
    Prescrip    text references Prescription(prNo),
    Drug        text references Drug(dno),
    primary key (Prescrip, Drug)

);
