/*
requirement: maintain assets in bank branches
1. each branch has assets based on the accounts held there
2. whenever an account changes, the assets of the corresponding branch
   should be updated to replect this change.
some possible changes
1. a new account is opened
2. the amount of money in the account changes
3. an account moves from one branch to another
4. an account is closed.
*/

-- a new account is opened
create trigger newaccount after INSERT on Account
for each row execute procedure newaccount();
create function newaccount() returns trigger
as $$
begin
    UPDATE   branches
    SET      assets = assets + new.balance
    where    branches.id = new.branch;
    return new;
end; $$ language plpgsql;

-- the amount of money in the account changes
create trigger balancechange after UPDATE on Account
for each row execute procedure balancechange();
create function balancechange() returns trigger
as $$
begin
    UPDATE   branches
    SET      asset = asset + (new.balance - old.balance)
    where    branches.id = new.branch;
    return new;
end; $$ language plpgsql;

-- an account moves from one branch to another
create trigger moves after UPDATE on Account
for each row execute procedure moves();
create function moves() returns trigger
as $$
begin
    -- moves out
    UPDATE branches
    SET    asset = asset - old.balance
    where  branches.id = old.branch;
    -- moves in
    UPDATE branches
    SET    asset = asset + new.balance
    where  branches.id = new.branch;
    return new;
end; $$ language plpgsql;

-- an account is closed
create trigger closed after DELETE on Account
for each row execute procedure closed();
create function closed() returns trigger
as $$
begin
    if (old.branch is not null) then
        UPDATE   branches
        SET      asset = asset - old.balance
        where    branches.id = old.balance;
    end if;
    returns old;
end; $$ language plpgsql;
