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