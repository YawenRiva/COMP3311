User Defined triggers
-- QUESTION 1
-- What command you need to use to delete/remove a trigger:
DROP TRIGGER trigger_name on table_name;
-- every trigger needs one of these
CREATE TRIGGER trigger_name
               AFTER operation
               ON table_name FOR EACH ROW
               EXECUTE PROCEDURE fuction_name()
CREATE TRIGGER teigger_name
               BEFORE operation
               ON table_name FOR EACH ROW
               EXECUTE PROCEDURE function_name()
-- trigger construction
CREATE FUNCTION function_name() RETURNS TRIGGER
AS $$
DECLARE
    ...
BEGIN
    ...
END;
$$ languagle plpgsql;

-- QUESTION 2
-- for UPDATE -> OLD + NEW
-- for INSERT -> NEW
-- for DELETE -> OLD

-- QUESTION 3
create table R(a int, b int, c text, primary key(a,b));
create table S(x int primary key, y int);
create table T(j int primary key, k int references S(x));
-- Primary key constraint on relation R
CREATE TRIGGER R_CHECK
               BEFORE INSERT OR UPDATE
               ON R FOR EACH ROW
               EXECUTE PROCEDURE R_CHECK();
CREATE FUNCTION R_CHECK() RETURNS TRIGGER
AS $$
BEGIN
    -- for INSERT, if a,b are empty then nothing needs to be update
    if (new.a is null or new.b is null) then
        raise exception 'partially specified primary key for R';
    end if;
    -- update if primary key are the ssame
    if (TG_OP = 'UPDATE' and old.a=new.a and old.b=new.b) then  
        return;
    end if;
    -- all the primary key needs to be unique
    -- once the already exists a equals to b it should raise exception
    select * from R where a=new.a and b.new.b;
    if (found) then
        raise exception 'duplicate primary key for R';
    end if;
end;
$$ language plpgsql;
-- QUESTION 4
CREATE TRIGGER UPDATES1
               AFTER UPDATE
               ON S1 FOR EACH ROW
               EXECUTE PROCEDURE UPDATES();
CREATE OR REPLACE FUNCTION UPDATES() returns TRIGGER
as $$
BEGIN
    UPDATE S
    SET y=y+1
    WHERE x=5;
    return new;
END;
$$ language plpgsql;


-- PRACTICE
CREATE TRIGGER NEWACCOUNT
               AFTER INSERT -- new
               ON ACCOUNT FOR EACH ROW
               EXECUTE PROCEDURE newaccount();
CREATE OR REPLACE FUNCTION newaccount() returns trigger
as $$
BEGIN
    UPDATE branches
    SET    asset = asset + new.balance
    WHERE  branches.id = new.branch;
    return new;
end;
$$ language plpgsql;

-- the amount of money in account changes
CREATE TRIGGER BALANCECHANGE
               AFTER UPDATE --new+old
               ON ACCOUNT FOR EACH ROW
               EXECUTE PROCEDURE balancechange();
CREATE OR REPLACE FUNCTION balancechange() returns trigger
as $$
BEGIN
    UPDATE branches
    SET    asset = asset + (new.balance = old.balance)
    WHERE  branches.id = new.branch;
    return new;
END;
$$ language plpgsql;

-- an account moves from one branch to another
-- one for REMOVE/DELETE
CREATE TRIGGER REMOVEACCOUNT
               AFTER UPDATE --old
               ON ACCOUNT FOR EACH ROW
               EXECUTE PROCEDURE removeaccout();
CREATE OR REPLACE FUNCTION removeaccount() returns trigger
as $$
BEGIN
    -- moves out
    UPDATE branches
    SET    asset = asset - old.balance
    WHERE  branches.id = old.branch;
    -- moves in
    UPDATE branches
    SET    asset = asset + new.balance
    WHERE  branches.id = new.branch;
    return new;
end;
$$ language plpgsql;

-- an account is closed
CREATE TRIGGER closeaccount
               AFTER DELETE
               ON ACCOUNT FOR EACH ROW
               EXECUTE PROCEDURE closeaccount();
CREATE OR REPLACE FUNCTION closeaccount() returns trigger
as $$
BEGIN
    -- check the old one is not null
    if (old.branch is not null) then
        update branches
        set asset = asset - old.balance
        where  branches.id = old.branch;
    end if;
    returns old;
end;
$$ language plpgsql;
