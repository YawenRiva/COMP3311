
-- Q1
-- List all the company names (and countries) that are incorporated outside Australia.
create or replace view Q1(Name, Country) as
select distinct(name), country
from company
where country != 'Australia';

-- Q2
-- List all the company codes that have more than five executive members on record (i.e., at least six).
create or replace view Q2(Code) as
select code from executive
group by code
having count(person) > 5;

-- Q3
-- List all the company names that are in the sector of "Technology"
create or replace view Q3(Name) as
select c.name
from company c, category a
where a.sector = 'Technology' and a.code = c.code;

-- Q4
-- Find the number of Industries in each Sector
create or replace view Q4(Sector, Number) as
select sector, count(distinct industry)
from category
group by sector;

-- Q5
-- Find all the executives (i.e., their names) that are affiliated with companies in the sector of "Technology"
-- If an executive is affiliated with more than one company, he/she is counted if one of these companies is in the sector of "Technology".
create or replace view Q5(Name) as
select (e.person)
from executive e, category c
where c.sector = 'Technology' and e.code = c.code;

-- Q6
-- List all the company names in the sector of "Services" that 
-- are located in Australia with the first digit of their zip code being 2.
create or replace view Q6(Name) as
select distinct(c.name)
from company c, category a
where c.country='Australia' and a.sector='Services' and c.zip like '2___' and c.code=a.code;

-- Q7
--
create or replace view Q7("Date", Code, Volume, PrevPrice, Price, Change, Gain) as
        select b."Date", b.code, b.volume, a.price as prevprice, b.price as price,
                (b.price-a.price) as change, ((b.price-a.price)/a.price)*100 as gain
        from asx a full join asx b on (a.code=b.code)
        where a."Date" = (select max("Date") from asx 
                          where code=b.code and "Date"<b."Date")
        order by b.code, b."Date";

-- Q8
-- Find the most active trading stock (the one with the maximum trading volume; if more than one
-- output all of them) on every trading day. Order your output by "Date" and then by Code.
create or replace view Q8("Date", Code, Volume) as
select "Date", code, volume from asx a
join (select "Date" as date, max(volume) as max
        from asx
        group by date)temp
on (a."Date" = temp.date and a.volume=temp.max)
order by "Date", code;

-- Q9
-- Find the number of companies per Industry. Order your result by Sector and then by Industry.
create or replace view Q9(Sector, Industry, Number) as
select sector, industry, count(code) as number
from category 
group by industry, sector
order by sector, industry;

-- Q10
-- List all the companies (by their Code) that are the only one in their Industry (i.e., no competitors).
create or replace view Q10(Code, Industry) as
select code, industry
from category c
join (select count(code), industry as ind from category 
      group by ind having count(code)=1)temp 
on (temp.ind=c.industry);

-- Q11
-- List all sectors ranked by their average ratings in descending order. 
-- AvgRating is calculated by finding the average AvgCompanyRating for each sector (where AvgCompanyRating is the average rating of a company).
create or replace view Q11(Sector, AvgRating) as
select c.sector, avg(r.star) as avgrating
from category c, rating r
where c.code=r.code
group by c.sector
order by avgrating desc;

-- Q12
-- Output the person names of the executives that are affiliated with more than one company.
create or replace view Q12(Name) as
select person as name from executive
group by person
having count(code)> 1;

-- Q13
-- Find all the companies with a registered address in Australia
-- in a Sector where there are no overseas companies in the same Sector
-- use the non-correlated subquery strategy
create or replace view Q13(Code, Name, Address, Zip, Sector) as
select c.code, c.name, c.address, c.zip, ca.sector
from company c, category ca
where ca.sector not in (select distinct sector from category where code 
                        in (select code from company where country != 'Australia'))
and ca.code=c.code;

-- Q14
-- Calculate stock gains based on their prices of the first trading day and last trading day
-- Order your result by Gain in descending order and then by Code in ascending order.
create or replace view Q14(Code, BeginPrice, EndPrice, Change, Gain) as
select distinct a.code, a2.price, a1.price, (a1.price-a2.price) as change, ((a1.price-a2.price)/a2.price)*100 as gain
from asx a
      join asx a1 on (a.code=a1.code)
            join (select code, max("Date") as date from asx
            group by code)temp1 on (temp1.date=a1."Date" and temp1.code=a1.code)
      join asx a2 on (a.code=a2.code)
            join (select code, min("Date") as date from asx
            group by code)temp2 on (temp2.date=a2."Date" and temp2.code=a2.code) 
order by gain desc, a.code asc;

-- Q15
create or replace view Q15(Code, MinPrice, AvgPrice, MaxPrice, MinDayGain, AvgDayGain, MaxDayGain) as
select code, min(price) as minprice, avg(price) as avgprice, max(price) as maxprice,
       min(gain) as mindaygain, avg(gain) as avgdaygain, max(gain) as maxdaygain
from Q7
group by code;

--  Q16
-- create trigger on the executive table
-- check and disallow any INSERT/UPDATE of a Person
-- in the table to be an executive of MORE THAN ONE company

-- one trigger for insert
create or replace function Insert() returns trigger
as $$
begin
-- if one person already exist, raise exception
    if (select count(person) from executive where person=new.person)>=1 then
        raise exception '% already exists in the table', new.person;
    else
        UPDATE  executive
        SET     code = new.code, person = new.person
        where   code = new.code and person = new.person;
    return new;
    end if;
end; $$ language plpgsql;
create trigger InsertCheking before INSERT on executive
for each row execute procedure Insert();

-- one trigger for update
-- update contains old and new
create or replace function Update() returns trigger
as $$
begin
-- if old data and new data are the same then no change
    if (old.person = new.person) and (old.code = new.code) then
        raise exception 'no data need to be update';
-- if the person only exist once, it can be updated
    elsif (select count(person) from executive where person=new.person)<=1 then
        UPDATE  executive
        SET     code = new.code, person = new.person
        where   code = new.code and person = new.person;
-- if the person already exists
-- change the value back to the old value
    elsif (select count(person) from executive where person=new.person)>1 then
        raise exception 'this person exist more than once';
    end if;
    return new;
end; $$ language plpgsql;
create trigger UpdateCheking before UPDATE on 
for each row execute procedure Update();

-- Q17
-- as sector is from category
-- gain is from question 7 new table
-- and we need to find max/min daily price gain for this question
create or replace view SectorGain("Date", sector, maxgain, mingain) as 
    select q7."Date", category.sector, max(q7.gain) as maxgain, min(q7.gain) as mingain
    from q7 inner join category on (q7.code = category.code)
    group by q7."Date", category.sector;
-- then we need few declare - local variable to store
create or replace function IncomingASX() returns trigger 
as $$
declare
    max float;
    min float;
    trigsector  text;
begin
    select sector into trigsector from category where category.code = new.code;
    select mingain into min from SectorGain where sector = trigsector and "Date" = new."Date";
    select maxgain into max from SectorGain where sector = trigsector and "Date" = new."Date";
    if (select gain from q7 where q7."Date"=new."Date" and q7.code=new.code) = min then
        UPDATE  rating
        SET     star = 1
        where   code = new.code;
    elsif (select gain from q7 where q7."Date"=new."Date" and q7.code=new.code) = max then
        UPDATE  rating
        SET     star = 5
        where   code = new.code;
    end if;
    return new;
end; $$ language plpgsql;

create trigger IncomingASX after INSERT on asx
for each row execute procedure IncomingASX();

-- Q18
-- create trigger
-- log updates on price/volue in the asx table
-- and log these updates into the asxlog table

create or replace function logforasx() returns trigger
as $$
begin
    -- asxlog contains
    -- timestamp, Date, code, oldvolume, oldprice
    insert into asxlog ("Timestamp", "Date", code, oldvolume, oldprice)
                values (current_timestamp, old."Date", old.code, old.volume, old.price);
    return null;
end; $$ language plpgsql;

create trigger logforasx after UPDATE on asx
for each row execute procedure logforasx();