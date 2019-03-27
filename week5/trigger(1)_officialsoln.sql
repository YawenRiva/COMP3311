--
--  Triggers to maintain Branch assets as
--    sum of Account balances at that branch
--

--
-- function to fix Branch assets when new account added
--
create or replace function
   include_new_customer_assets() returns trigger
as $$
begin
   update Branches
   set    assets = assets + new.balance
   where  location = new.branch;
   return new;
end;
$$ language plpgsql;

--
-- set trigger to invoke function when new Account tuple inserted
--
create trigger new_assets
after insert on Accounts
for each row execute
procedure include_new_customer_assets();


-- function to adjust Branch assets for cases:
-- * customer deposits funds into account
-- * customer withdraws funds from account
-- * customer moves account to a different branch

create or replace function
   update_customer_assets() returns trigger
as $$
begin
   update Branches
   set    assets = assets - old.balance
   where  location = old.branch;
   update Branches
   set    assets = assets + new.balance
   where  location = new.branch;
   return new;
end;
$$ language plpgsql;

--
-- set trigger to invoke function when Account tuple updated
--
create trigger changed_assets
after update on Accounts
for each row execute
procedure update_customer_assets();
