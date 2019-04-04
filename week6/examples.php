
$db = pg_connect("dbname = mydb");
# or
$cp = "dbname=hisdb user=fred password=abc";
$db = pg_connect($cp);

example: PG_CONNECT()
$unidb = pg_connect("dbname = UniDB");
$query = "select name from Staff where dept=2";
$result = pg_query($unidb, $query);
if (!$result)
	print "something wrong with query!\n"
else
	// proess the result set...
// to find ouu exactly what was wrong with query
if (!$result)
	print pg_last_error();


example: PG_QUERY()	
$query = "select * from emplyees where department='sales'";
$result = pg_query($db, $query);
if (!$result)
	print pg_last_error();
else if (pg_num_rows($result) > 20)
	print"this is a very big department\n";


example: PG_AFFECTED_ROW()
$query = "delete from Enrolments where course='COMP3311'";
$result = pg_query($db, $query);
if (!result)
	print pg_last_error();
else {
	$nstudes = pg_affected_rows($result);
	print "dropped $nstudes from COMP3311\n";
}



example: PG_FETCH_ROW()
$query = "select id, name from Staff";
if ($result = pg_query($db, $query)) {
	// the number of rows in the result
	$n = pg_num_rows($result);
	for ($i=0;$i<$n;$i++) {
		// each item now is one row/tuple
		// so you can choose which field/column to print
		$item = pg_fetch_row($result,$i);
		print "Name=$item[1], StaffID=$item[0]\n";
	}
}



example: PG_FETCH_ARRAY ()
$query = "select id, name from Staff";
if (!($result = pg_query($db, $query)))
	// combine the msg with error checking
	print "Error: ".pg_last_error();
else {
	$n = pg_num_rows($result);
	// iterator, use pg_fetch_Array instead
	// you can also access to the field name instead of only position
	// like the pg_fetch_rows()
	for ($i=0;$i<$n;$i++) {
		$item = pg_fetch_array($result,$i);
		$nm = $item["name"];$id = $item["id"];
		print "Nmae=$nm, StaffId=$id\n";
	}
}












