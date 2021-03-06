-- PRACTICE
create or replace function squares(hi integer) returns setof Pair
as $$
declare
    i integer;
    p pair;
begin
    for i in 1..hi loop
        p.x = i;
        p.y = i*i;
        return next p;
    end loop;
    return;
end;
$$ language plpgsql;

functions returning single atomic value
CREATE OR REPLACE FUNCTION add(a integer, b integer) return integer
as $$
begin
    return a+b;
end;
$$ language plpgsql;

-- function return a single tuple
CREATE OR REPLACE FUNCTION mkpair(a integer, b integer) return pair
as $$
declare
    p pair;
begin
    p.x := a;
    p.y := b;
    return p;
end;
$$ language plpgsql;

-- QUESTION 1
-- write a fuction to calculate square of real numbers
CREATE OR REPALCE function sqr(n integer) returns integer
as $$
declare
    result integer;
begin
    result := n*n;
    return result;
end;
$$ language plpgsql;

CREATE OR REPALCE function sqr(n numeric) returns numeric
as $$
begin 
    return n * n;
end;
$$ language plpgsql;

-- QUESTION 2
-- calculate factorial
-- recursive
CREATE OR REPLACE function factorial(n integer) returns integer
as $$
begin
    if (n=0) return 1;
    elsif (n<0) return null;
    elsif (n=1) return 1;
    else
       return n * fac(n-1);
    endif;
end;
$$ language plpgsql;
--loop
CREATE OR REPLACE FUNCTION factorial(n integer) return integer
as $$
declare
    i integer;
    result integer;
begin
    if (n<0) return null; endif;
    result := 1;
    i:=1;
    while (i <= n) loop
        result := i*result;
        i:=i+1;
    end loop;
    return res;
end;
$$ language plpgsql;

-- QUESTION 3
-- print string
CREATE OR REPLACE FUNCTION spread(text) return text
as $$
declare
    result text := '';
    i integer;
    len integer;
begin
-- $1 means first row
    len := length($1);
    i:=1;
    while (i<len) loop
        result = result || substr($1, i, 1) || '';
        i:=i+1;
    end loop;
    return result;
end;
$$ language plpgsql;

-- QUESTION 4
create or replace function seq(n integer) returns setof integer
as $$
declare
    i integer;
begin
    i:=1;
    while (i<n) loop
        return next i; -- append more rows to the result set
        i := i+1;
    end loop;
    return;
end;
$$ language plpgsql;
 
-- QUESTION 8
CREATE OR REPLACE FUNCTION hotelsIn(_addr text) returns text
as $$
declare
    bar record;
    result text :='';
begin
    for bar in select * from bars where addr = _addr
    loop 
        result:= result || r.name || '\n';
    end loop;
    return result;
end;
$$ language plpgsql;

-- QUESTION 12
create or replace function
	hotelsIn(text) returns setof Bars
as $$ 
	select * from Bars where addr = $1;
$$ language sql;
