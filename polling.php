<?php 
header("content-type: application/json");
// $bash = exec("bash battery.sh JSON"); 

$bashArray = array();
$finalArray = array();
$bashArray = explode(',', $bash);

$finalArray['Date_Nice']  = $bashArray[0];
$finalArray['Date_Epoch']  = $bashArray[1];
$finalArray['Batt_Cycle']  = $bashArray[2];
$finalArray['Batt_rem_perc']  = $bashArray[3];
$finalArray['Batt_Charge_rem']  = $bashArray[4];
$finalArray['Batt_Time_Left_mins']  = $bashArray[5];
$finalArray['Batt_Time_Left_time']  = $bashArray[6];
$finalArray['Batt_Status_indicator']  = $bashArray[7];
$finalArray['Batt_AmperageMA']  = $bashArray[8];
$finalArray['POWER']  = $bashArray[9];
$finalArray['Batt_Health']  = $bashArray[10];
$finalArray['Batt_Charge_cap']  = $bashArray[11];
$finalArray['Batt_Status']  = $bashArray[12];
$finalArray['Ram_Total']  = $bashArray[13];
$finalArray['Ram_Free']  = $bashArray[14];
$finalArray['Ram_Used']  = $bashArray[15];
$finalArray['Ram_Perc_Free']  = $bashArray[16];
$finalArray['Batt_Warn']  = $bashArray[17];
$finalArray['Cpu_Load_Average1']  = $bashArray[18];
$finalArray['Cpu_Load_Average5']  = $bashArray[19];
$finalArray['Cpu_Load_Average15']  = $bashArray[20];
$finalArray['Cpu_Perc_Free']  = $bashArray[21];
$finalArray['Cpu_Perc_User']  = $bashArray[22];
$finalArray['Cpu_Perc_Sys']  = $bashArray[23];
$finalArray['Wifi_Status']  = $bashArray[24];
$finalArray['Wifi_Connected']  = $bashArray[25];
$finalArray['Ping']  = $bashArray[26];
$finalArray['Display_Brightnes_perc']  = $bashArray[27];
$finalArray['executed_in']  = $bashArray[28];

echo json_encode($finalArray);

// TODO: this needs work
/// json for flot
/// http://people.iola.dk/olau/flot/examples/data-eu-gdp-growth.json
// {
//     "label": "Europe (EU27)",
//     "data": [[1999, 3.0], [2000, 3.9], [2001, 2.0], [2002, 1.2], [2003, 1.3], [2004, 2.5], [2005, 2.0], [2006, 3.1], [2007, 2.9], [2008, 0.9]]
// }