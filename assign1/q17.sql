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