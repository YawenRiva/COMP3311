/*
Person(id:integer, ..., name:text, ...)
Student(id:integer, sid:integer, stype:('local','intl'))
Staff(id:integer, sid:integer, office:integer, ...)
Term(id:integer, year:integer, session:('S1','S2','X1','X2'), ...)
Subject(id:integer, code:text, ..., name:text, ... uoc:integer, ...)
Course(id:integer, subject:integer, term:integer, lic:integer, ...)
*/
/*Write a PLpgSQL function to produce the complete name of an OrgUnit:
function unitName(_ouid integer) returns text*/
Create or replace function unitName(_ouid integer) returns text
as $$
declare
  _typename text;
  _compeletename text;
begin
  select * from orgunit where id=_ouid;
  if (not found) then
    raise exception 'no such unit:%',_ouid;
  end if;
  select t.name, u.longname into _typename, _completename
  from orgunittype t, orgunit u
  where u.id=_ouid and u.utype=t.id;
  
  if (_typename = 'UNSW') then return 'UNSW';
  elsif (_typename = 'Faculty') then
    return _completename;
  elsif (_typename = 'school') then
    return 'school of'||_compeletename;
  elsif (_typename='centre') then
    return 'centre for'||_compeletename;
  elsif (_typename='institute') then
    return 'institute of'||_compeltename;
  else return null;
  end if;
end;
$$ language plpgsql;



-- Question1
create or replace function sqr(n integer) returns integer
as $$
begin
  return n*n;
end;
$$ language plpgsql;
-- or 
create or replace function sqr(n integer) returns integer
as $$
declare
  square integer;
begin
  square := n * n;
  return square;
end;
$$ language plpgsql;


--Question 2
create or replace function fac(n integer) returns integer
as $$
delare
  i integer; result integer;
begin
  if (n < 0) then return null;
  elsif (n = 0) then return 1;
  elsif (n = 1) then return 1;
  else
    i := 0;
    result := 1;
    while (i < n) loop
      result := result * i;
      i := i+1;
    end loop;
    return result;
  end if;
end;
$$ language plpgsql;



-- question 3
create or replace function spread(text) returns text
as $$
declare
  i integer; len integer; result text;
begin
  result := '';
  len := length($1);
  i := 0;
  while (i < len) loop
    result := result||substr($1,i,1)||' ';
    i:=i+1
  end loop;
  return result;
end;
$$ language plpgsql;


-- question 4
create or replace function seq(n integer) returns setof IntVal
as $$
declare
  i integer; result IntVal;
begin
  i := 0;
  while (i < n) loop
    result.val = i;
    return next rl
    i := i + 1;
  end loop;
  return;
end;
$$ language plpgsql;
