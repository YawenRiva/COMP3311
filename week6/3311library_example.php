1.
$db = dbConnect("dbname = mydb");
...
$min = ...;
$query = "select a,b,c from R where c >= %d";
// the php variable $min will be as the %d 
$result = dbQuery($db, mkSQL($query,$min));
while ($tuple = dbNext($r)) {
// call the result one by one by dbNext instead of pg_fetch_array
	list($a,$b,$c) = $tuple;
	$tmp = $a - $b - $c;
	# or
	$tmp = $tuple["a"] - $tuple["b"] - $tuple["c"];
}

example: MKSQL()
$name = "O'Brien";
$tmpl = "select * from Employees".
	"where name = %s and salary > %d";
$qry = mkSQL($tmpl, $name, 50000);
// which produces the query string
// select *from Employees
// where name = 'O'Brien' and salary > 50000

example:
$db = accessDB("mymyunsw");
$query = <<_SQL_
select s.sid, p.name
from students s, prople p, courses c, subject sb, courseEnrol e, terms t
where s.id = p.id and e.student = s.id and e.course = c.id
      and c.subject = su.id and su.code = %s and c.term = t.id
      and t.year = %d and t.sess = %s
order by s.sid
_SQL_;
// $subj, $year, $sess for the three para,s, %s, %d, %s above
$sql = mkSQL($query, $subj, $year, $sess);
// you can then execute the query, and get the result out
$result = dbQuery($db, $sql);
// each tuple t from the db
while ($t = dbNext($result)) echo "$t[sid] $t[name]\n";




















