<?php 
header("content-type: application/json");
$bash = exec("bash battery.sh"); 

$bashArray = array();
$finalArray = array();
$bashArray = explode(',', $bash);

$finalArray['BatteryPercent']  = $bashArray[0];
$finalArray['BatteryCycle']  = $bashArray[1];
$finalArray['BatteryCapacity']  = $bashArray[2];
$finalArray['BatteryRemaining']  = $bashArray[3];
$finalArray['BatteryStatus']  = $bashArray[4];
$finalArray['RamTotal']  = $bashArray[5];
$finalArray['RamUsed']  = $bashArray[6];
$finalArray['RamUsedPercent']  = $bashArray[7];
$finalArray['BatteryWarn']  = $bashArray[8];
$finalArray['CpuLoad']  = $bashArray[9];
$finalArray['CpuFree']  = $bashArray[10];
$finalArray['CpuUser']  = $bashArray[11];
$finalArray['CpuSystem']  = $bashArray[12];

echo json_encode($finalArray);