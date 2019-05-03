drop view if exists q1;
create or replace view q1 as

select t.country as team, g.matches as matches
from teams t
join (
select count(match) as matches, team
from involves
group by team
)g on (g.team=t.id);
