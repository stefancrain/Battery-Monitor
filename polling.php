<?php 
header("content-type: application/json");
$bash = exec("bash battery.sh"); 

$bashArray = array();
$finalArray = array();
$bashArray = explode(',', $bash);

$finalArray['BatteryChargePercent']  = $bashArray[0];
$finalArray['BatteryCycle']  = $bashArray[1];
$finalArray['BatteryCapacity']  = $bashArray[2];
$finalArray['BatteryRemaining']  = $bashArray[3];
$finalArray['BatteryStatus']  = $bashArray[4];
$finalArray['RamFree']  = $bashArray[5];
$finalArray['BatteryLowPower']  = $bashArray[6];
$finalArray['CpuLoad']  = $bashArray[7];
$finalArray['CpuPercentFree']  = $bashArray[8];
$finalArray['CpuPercentUser']  = $bashArray[9];
$finalArray['CpuPercentSystem']  = $bashArray[10];

echo json_encode($finalArray);