// QUESTION 1 
// For PHP the variable/local variale type can be change, always look at the last one
$x = 3.0;                    // now $x == float(3.0)
$x = (int)$x / 2;            // now $x == float(1.5)
$x = 1+(int)$x*2;            // 1+2 -> $x== int(3)
$x = "$x times $x";          // $x == string("3 times 3")
$x = $x * 5 / 3;             // 15/3 $x == int(5)
$x = 'Why $x?';              // $x == string("why $x?")
$x  = $x + 3.14159;          // $x = 3.14159
// 单引号 没有任何意义，不经过任何处理直接拿过来
// 双引号 php动态处理过后然后输出，一般用一变量
// \n 换行 + \r 送出 + \t 跳位

// QUESTION 2
// what is the difference between the following three php operators
// =, ==, ===
/*
= is assignment, its left hand side must be a variable and right hand side is an
expression. the expression is evaluated and cast to an appropriate type to assign variable
*/
/*
== represents equality test, its LHS nad RHS are both expressions.
both expressions are evaluated, cast to compatible types and their values are compares.
if the values are equal -> TRUE, otherwise FALSE
*/
/*
=== represents the exact equality test.
e.g. $v1 = "1", $v2= 1
($v1 == $v2) TRUE
($v1 === $v2) FALSE
*/

// QUESTION 3
//What is the effect of putting an @ character at the start of a function call? (e.g. writing @pg_connect(...) rather than pg_connect(...))?
// @ 不显示错误信息
// @ this character control the error message for the duration of the function call
// so that can get the return value check for error and then handle it in a way thats appropriate for the script

// QUESTION 4

// For each of the following PHP statements, list the possible errors that might occur and state what value would be assigned to the variable on the left-hand side of the assignment, if an error occurs.
// $db = pg_connect("dbname=abc user=fred password=$secret")
// abc is not name of a database + fred is not a name of user + $secret is null or is not freds password
// it will returns false on error

// $res = pg_query($db, "select beer from Sells where price < $max")
// $db is not a valid database connection source
// $max is not set  or its a non-numeric value

// $ntups = pg_num_rows($res)
// $res doesnt have a valid query result resources value
// retuens -1 on error, if there is valid return value thenn 0

// $tuple = pg_fetch_row($res)
// $res doesnot have a valid query result resource value
// returns null on error

// QUESTION 5
<?
$x = 25;  $y = "O'Brien";  $z = "'%'; delete from Employees";

echo mkSQL("select * from Employees where age > %d", $x); // employee older than 25
echo "\n";
echo mkSQL("select * from Employees where name like %s", $x); // employee's name like 25
echo "\n";
echo mkSQL("select * from Employees where name = %d", $y); // name = 0
echo "\n";
echo mkSQL("select * from Employees where name like %s", $y);  // name like 'o''brien'
echo "\n";
echo mkSQL("select * from Employees where name like %s", $z);
echo "\n";
echo mkSQL("select * from Employees where salary > 50000");
echo "\n";
echo mkSQL("select * from Employees where name like %s and age = %d", $y, $x);
echo "\n";
?>


// QUESTION 6
<?
$connection = @pg_connection ("dbname = GOODPUBGUIDE"); // 连接database
if (!$connection)
    exit ("cannot connect to the database GOODPUBGUIDE");
$result = @pg_query ($connection, "select * from bars");  // 在database $connection里面运行SQL QUERY
if (!$result)
    exit ("cannot get result for the query");
$num = pg_num_rows($result);
for($i = 0; $i < $num, $i++) {
    $tuple = pg_fetch_row($result,$i); // 把每一行单独提出来输出
    $name = $tuple[0];
    $addr = $tuple[1];
}
?>
//另外一种写法 用db php里面得写
<?
require ("db.php"); // require the php file 
$db = dbConnect("dbname = GOODPUBGUIDE"); // dbConnect = @pg_connection
$q = "select * from bars";
$r = dbQuery($db, mkSQL($q)); // dbQuery = @pg_query
while ($t = dbNext($r)) { // dbNext($r) = pg_num_rows + pg_fetch_row
...
}
?>


