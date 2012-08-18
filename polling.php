<?php 

header("content-type: application/json");
$bash = exec("bash battery.sh"); 

$myArray = array();
$finalArray = array();

$myArray = explode(',', $bash);

$finalArray['Percent']  = $myArray[0];
$finalArray['Cycle']  = $myArray[1];
$finalArray['Capacity']  = $myArray[2];
$finalArray['Remaining']  = $myArray[3];
$finalArray['Activity']  = $myArray[4];
$finalArray['Ram_Usage']  = $myArray[5];

echo json_encode($finalArray);
