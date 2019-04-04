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
create trigger UpdateCheking before UPDATE on executive
for each row execute procedure Update();