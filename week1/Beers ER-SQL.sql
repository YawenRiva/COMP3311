/*convert the design to something thats implementable*/
-- Beer Database SQL Schema


/*TEXT has fixed max size (same as CHAR)
  VARCHAR() has variable max size
  if have MAX size known, varchar(n) would be a better choice*/
-- ENTITIES
create table Beers (
    name    text, -- or varchar(100)
    manf    text not null, -- or varchar(80)
    primary key (name)
);
create table Bars (
    name    text,
    addr    text not null,
    -- licence# has a particular format and always 10 character long
    -- so use fixed-length 'char(n)'
    lic_no  char(10) not null,
    primary key (name)
);
create table Drinkers (
    name    varchar(60), -- or text
    phone   integer not null,
    addr    char(15) not null,
    primary key(name)
);

-- RELATIONSHIPS
/*
  PRIMARY KEY is for ENTITY only
  NOT FOR RELATIONSHIP SETS
*/
create table sells (
    price   float not null,
    beers   text references Beers(name),
    bars    text references Bars(name),
    primary key(beers, bars)
);

create table likes (
    -- if the type of attribute is VARCHAR/CHAR()
    -- the length need to be the same as the length in above entity table
    beers   text references Beers(name),
    drinkers    text references Drinkers(name),
    primary key(beers, drinkers)
);

create table frequents (
    bars   text references Bars(name),
    drinkers    text references Drinkers(name),
    primary key(bars, drinkers)
);
