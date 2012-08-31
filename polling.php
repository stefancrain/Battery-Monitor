<?php 
header("content-type: application/json");
// $bash = exec("bash battery.sh"); 

$bashArray = array();
$finalArray = array();
$bashArray = explode(',', $bash);


/// json for flot
/// http://people.iola.dk/olau/flot/examples/data-eu-gdp-growth.json
// {
//     "label": "Europe (EU27)",
//     "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3], [2004, 2.5], [2005, 2.0], [2006, 3.1], [2007, 2.9], [2008, 0.9]]
// }

// our data comes out like - 
// nice_date,since_epoch,Batt_Cycle,Batt_rem_perc,Batt_Charge_rem,Batt_Time_Left_mins,Batt_Time_Left_time_string,Batt_Status_indicatorBatt_AmperageMA,wattage,Batt_Health,Batt_state,Batt_Warning_Status,Ram_Total,Ram_Free,Ram_Used,Ram_Perc_Free,Batt_Warning_Status,Cpu_Load_Average,Cpu_Perc_Free,Cpu_Perc_User,Cpu_Perc_Sys,Wifi_Status



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