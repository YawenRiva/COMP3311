-- factorial n!
-- function fac(n integer) returns integer
create or replace function fac (n integer) returns integer
as $$
declare
    i integer;
    f integer := 1;
begin
    -- if n<1 then unable to find fac then raise exceptions
    if (n < 1) then
        raise exception 'Invalic fac(%)', n;
    end if;
    -- eg. 5! = 5*4*3*2*1
    -- while loop when i<=n i++
    -- f stores the result = i*f
    i := 1;
    while (i <= n) loop
        f := f * i;
        i := i + 1;
    end loop;
    return f;
end;
$$ language plpgsql


-- returns integers 1..hi
-- because of this function needs to return a set of integers
-- then we need to create type
create type IntVal as (val integer);
create or replace function iota(hi integer) returns setof IntVal
as $$
declare
    i integer;
    v IntVal;
begin
    for i in 1.._hi
    loop
        -- put i into v.val
        v.val := i;
        -- after put the value into the IntVal
        -- check the nect i for v
        return next v;
    end loop;
    return;
end;
$$ language plpgsql


-- returns integers lo..hi
create type IntVal as (val integer);
create and replace function iota(lo integer, hi integer) returns setof IntVal
as $$
declare
    i integer;
    v IntVal;
begin
    for i in _lo.._hi
    loop
        v.val := i;
        return next v;
    end loop;
end;
$$ language plpgsql
