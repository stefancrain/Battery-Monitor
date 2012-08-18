<?php 
header("content-type: application/json");
$arr = exec("bash battery.sh"); 
// $arr = stripslashes($arr);
// echo json_encode($arr);
echo $arr;