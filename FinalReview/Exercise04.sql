-- QUESTION 1
-- Consider the following relational schemas
Suppliers(
    sid integer primary key,
    sname text, 
    address text
);
Parts(
    pid integer primary key,
    pname text, 
    colour text
);
Catalog(
    sid integer references Suppliers(sid),
    pid integer references Parts(pid),
    cost real,
    primary key (sid,pid)
);

-- a. find the names of suppliers who supply some red part
select s.sname
from   Suppliers s, Parts p, Catalog c
where  p.colour = 'red' and s.sid = c.sid and p.pid = c.pid;

-- b. find the sids of suppliers who supply some red or green part
select s.sid
from   Suppliers s, Parts p, Catalog c
where  s.sid = c.sid and p.pid = c.pid and (p.colour = 'red' or p.colour = 'green');

-- c. find the sids of supplier who supply some red part or whose address is 221 packer street
select s.sid
from   Suppliers s
where  s.address = '221 Packer Street'
or   s.sid in (
                select c.sid
                from   Catalog c, Parts p
                where  p.colour = 'red' and p.pid = c.pid
                );

-- d. find the sids of suppliers who supply some red part and some green part
(select C.sid
 from Parts P, Catalog C
 where P.color='red' and P.pid=C.pid
)
intersect
(select C.sid
 from Parts P, Catalog C
 where P.color='green' and P.pid=C.pid
)

select C.sid
from   Parts P, Catalog C
where  P.color='red' and P.pid=C.pid
       and C.sid in (select C2.sid
                   from   Parts P2, Catalog C2
                   where  P2.color='green' and C2.sid=C.sid and P2.pid=C2.pid
                  )

-- e. find the sids of supplier who supply everypart
select c.sid
from catelog c
where not exist (
                select distinct p.pid 
                from Parts p
                where p.pid not in
                (select c1.pid from Catalog c1 where c1.sid = c.sid)
                )

-- f. find the sids of supplier who supply every red part
select s.sid
from Supplier s
where not exists (
                (select c.sid from catelog c where c.sid = s.sid)
                except
                (select c1.sid from catelog c1, parts p where p.colour='red' and c1.pid=.p.pid)
                );

-- g. find the sids of suppselect s.sid
from Supplier s
where not exists (
                (select c.sid from catelog c where c.sid = s.sid)
                except
                (select c1.sid from catelog c1, parts p where p.colour='red' and c1.pid=.p.pid)
                )
OR not exists (
                (select c.sid from catelog c where c.sid = s.sid)
                except
                (select c1.sid from catelog c1, parts p where p.colour='green' and c1.pid=.p.pid)
                )
                )

SOLUTION
select S.sid
from   Suppliers S
where  not exists((select P.pid from Parts P
                   where P.color='red' or P.color='green')
                  except
                  (select C.pid from Catalog C where C.sid=S.sid)
                 )


-- h. every red part or every green part
(select S.sid
 from   Suppliers S
 where  not exists((select P.pid from Parts P where P.color='red')
                   except
                   (select C.pid from Catalog C where C.sid=S.sid)
                  )
)
union
(select S.sid
 from   Suppliers S
 where  not exists((select P.pid from Parts P where P.color='green')
                   except
                   (select C.pid from Catalog C where C.sid=S.sid)
                  )
)

-- i. Find pairs of sids such that the supplier with the first sid charges more for some part than the supplier with the second sid.
select sh.sid, low.sid
from Supplier sh, catelog c
where sh.sid = c.sid
JOIN (
    select sl.sid, cl.cost, cl.pid
    from supplier sl, catelog cl
    where sl.sid = sl.sid
)low on (low.pid = c.pid and low.cost < c.cost)


select C1.sid, C2.sid
from   Catalog C1, Catalog C2
where  C1.pid = C2.pid and C1.sid != C2.sid and C1.cost > C2.cost

-- j. Find the pids of parts that are supplied by at least two different suppliers.
select c.sid
from catelog c
where exists (
    select c1.sid from catelog c1
    where c1.sid != c.sid and c1.pid = c.pid
);

-- k.Find the pids of the most expensive part(s) supplied by suppliers named "Yosemite Sham".
select c.pid
from Suppliers s, catelog c
where s.sname = 'Yosemite Sham' and c.sid=s.sid
and c.cost = (select max(cost) from catelog where sid = s.sid);


select C.pid
from   Catalog C, Suppliers S
where  S.sname='Yosemite Sham' and C.sid=S.sid and
       C.cost >= all(select C2.cost
                     from   Catalog C2, Suppliers S2
                     where  S2.sname='Yosemite Sham' and C2.sid=S2.sid
                    )
