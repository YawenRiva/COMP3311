<?php
for ($i = 0; $i < count($word); $i++)
// $word = array("a"," b","c")
// count() count the element of array
    print "word[$i] = $word[$i]\n";
// output:
// word[0]=a, word[1]=b, word[2]=c
?>

another way to do it
<?php
foreach ($words as $w)
// for each element in the array will be view as $w
    print "word = $w\n"
?>

<?php
// reset() = set the array's internal pointer
// back to the first element in the array

// key() = current internal pointer position
// which is similar to the index for c
for (reset($marks); $name = key($marks)); next($marks))
    print "mark for $name = $marks[$name]\n"
?>

