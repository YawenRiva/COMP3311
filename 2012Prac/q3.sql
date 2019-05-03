DROP VIEW IF EXISTS Q3;
CREATE VIEW Q3 AS

select t.country as team, max(g.count) as players
from teams t
join (
select count(id) as count, memberof as teamid
from players
where id not in(select distinct scoredby from goals)
group by memberof
)g on (g.teamid = t.id);

