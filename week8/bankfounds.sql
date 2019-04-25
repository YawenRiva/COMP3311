/*
Bank funds transfer
move N dollars from account X to account Y
Accounts(id,name,balance,heldAt, ...)
Branches(id,name,address,assets, ...)
maintain Branches.assets as sum of balances via triggers


transfer implemented by function which
1. has three parameters: amount, source acct, dest acct
2. checks validity of supplied accounts 
3. checks sufficient available funds (one local val needed)
4. returns a unique transaction ID on success
*/

create or replace function TRANSFER (N integer, X text, Y text) return integer
-- now need to declare few local variables
declare
xid integer --store the account id for X
yid integer --store the account id for Y
availaable integer --store the avaliable balance from account X

begin
  select id, balance into xid, available
  from Accounts
  where name = X;
  -- check if the account is validity for 2.
  if (xid is null) then
    raise exception 'this source account doesnt exist %', X;
  end if;
  
  select id into yid
  from Accounts
  where name = Y;
  if (yid is null) then
    raise exception 'this dest account doesnt exist %', Y;
  endif;
  
  -- now check the available balance in the account X, if its not enough then raise exception
  if (available < N) then
    raise exception 'insufficient fund in %', X;
  endif;
  
  -- else, then there is avaliable amount, do the transfer process
  UPDATE  Accounts
  SET     balance = balance - N
  WHERE   id = xid;
  
  UPDATE  Accounts
  SET     balance = balance + N
  WHERE   id = yid;
  
  return nextval ('tx_id_seq');
  
END;
