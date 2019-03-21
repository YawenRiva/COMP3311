-- 1. what beers are made by Toohey's?
-- because of Tooheys is a manf which is in beers table
select distinct(name) from beers
where manf = 'Toohey''s';

-- 2. show beers with heading "beer", "brewer"
select name as beer, manf as Brewer from beers;
-- as command is used to rename a column or table with an alias

-- 3. find the breswers whose beers John likes
-- need drinkers & beer from likes and manf from beers
-- all the primary key are distinct/unique
-- when you printing primary key no distinct needed
select distinct beers.manf as Breswers from likes
join beers on (likes.beer=beer.name)
where likes.drinker = 'John';
-- or
select distinct beers.manf as breswers
from beers, likes
where likes.drinker='John' and likes.beer=beers.name; 

-- 4. find pairs of beers by the same manufacturer
select b1.name, b2.name
from beers b1 join beers b2 on (b1.manf=b2.manf)
where b1.name<b2.name;
-- or
select b1.name, b2.name
from beers b1, beers b2
where b1.manf=b2.manf and b1.name<b2.name;

-- 5. find beers that are the only one by their brewer
-- using non-correlated subquery strategy
select name from beers
where manf in (select manf from beers
               group by manf
               where count(name) == 1);
-- or using correlated subquery strategy
-- not exists-if two 
select b.name from beers b
where not exists (
    select * from beers b1
    -- manf are the same, beers are not the same from two tables
    -- if any other beers exist in the table b1
    -- which is not the same name as the beer in b means it has more than 1
    where b1.manf=b.manf and b1.name<>b.name
);

-- 6. find the beers sold at bars where John drinks
-- my answer
select distinct sells.beer from frequents join sells
on (frequents.bar=sells.bar)
where frequents.drinker='John';
-- or
select distinct beer
from frequents f, bars b, sells s
where f.drinker='John' and f.bar=b.name and b.name=s.bar;
-- or
select distinct beer from frequents f
    join bars b on f.bar=b.name
    join sells s on b.name=s.bar
where f.drinker='John'

-- 7. how many different beers are there
-- because name is the primary key of the table so it has to be unique
select count(name) from beers;

-- 8. how many different brewers are there 
select count(distinct manf) from beers;

-- 9. how many beers does each brewer make?
select manf, count(name) from beers
group by manf;

-- turn it into a view
create view brewersbeers(brewer, nbeers) as
select manf, count(name)
from beers
group by manf;

-- 10. which brewer makes the most beers
select brewer from brewersbeers
where nbeers = (select max(nbeers) from brewersbeers);

-- 11. bars where either Gernot or John drink
select bar from frequents
where drinker='Gernot' or drinker='John';
-- or
select bar from frequents
where drinker in ('Gernot','John');
-- or
(select bar from frequents where drinker='Gernot')
union -- add all if doesnt need duplicates
(select bar from frequents where drinker='John')


-- 12. bars where both Gernot and John drinks
(select bar from frequents where drinker='Gernot')
intersect
(select bar from frequents where drinker='John')
-- or
select f1.bar, f1.drinker, f2.drinker
from frequents f1 join frequents f2 on (f1.bar=f2.bar)
where f1.drinker='Gernot' and f2.drinker='John';


-- 18. which beers are sold at all bars
select namr from beers b
-- except is like ab-bb not exists is like 'isempty'
-- thus its like if the list of (bar-barsellsbeers) is empty
-- then every bar sells the beer
where not exists (
    (select name from bars)
    except
    (select bar from sells where beer=b.name)
)
-- or
select beer, count(bar)
from sells
group by beer
having count(bar)=(select count(*) from bars);

