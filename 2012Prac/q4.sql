drop view if exists matchtable;
create view matchtable as
select t1.country as c1, t2.country as c2, count(*) as num
from teams t1, teams t2, involves i1
where t1.id = i1.team and t2.id in (select team from involves where match=i1.match)
and t1.country<t2.country
group by t1.country,t2.country
order by t1.country,t2.country;

drop view if exists aq4;
create view aq4 as
select c1, c2, num
from matchtable
where num = (select max(num) from matchtable);

