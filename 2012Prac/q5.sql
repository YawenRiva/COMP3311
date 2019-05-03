
drop view if exists yellowtable;
create view yellowtable as
select t.country as team, count(*) as yellow
from teams t
join(
    select memberof from players
    where id in (select givento as playerid from cards where cardtype = 'yellow')
)g on (t.id = g.memberof)
group by t.country;


drop view if exists redtable;
create view redtable as
select t.country as team, count(*) as red
from teams t
join(
    select memberof from players
    where id in (select givento as playerid from cards where cardtype = 'red')
)g on (t.id = g.memberof)
group by t.country;


drop view if exists q5;
create view q5 as
select t.country as team, coalesce(r.red,0), coalesce(y.yellow,0)
from teams t
left outer join redtable r on (r.team = t.country)
left outer join yellowtable y on (y.team = t.country)
where t.country in (select team from redtable) or t.country in (select team from yellowtable);

