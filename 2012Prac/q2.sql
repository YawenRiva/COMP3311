drop view if exists q2;
CREATE OR REPLACE VIEW q2 AS

select p.name as player, g.goals as goals
from players p
join (
    select count(rating) as goals, scoredby as playerid
    from goals
    where rating = 'amazing'
    group by scoredby
)g on (g.playerid = p.id)
where g.goals > 1;
