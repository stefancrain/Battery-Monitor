#!/bin/bash

#Name of the user.
name=`whoami`

Ram_Total=`sysctl -n hw.memsize | awk '{print $0/1073741824}'`
Ram_Usage=`top -u -R -l1 | grep 'PhysMem' | cut -c 65-68 | awk '{print $0/1024}'`
Ram_Perc=$(echo "$Ram_Usage"/"$Ram_Total"*100 | bc -l)
Ram_Perc=$(echo "$Ram_Perc" |cut -c 1-5)

Cpu_Load_Average=`w | head -n1 | awk '{print $10}'`
# Cpu_Number=`sysctl hw.ncpu | awk '{print $2}'`
# Cpu_Number=$(echo "$Cpu_Number" |cut -c 1-4)

# Using -l2 .. tail -n1 because -l1 gave me shitty results
Cpu_Perc_Free=`top -l2 -F -R -u | grep "CPU usage" | tail -n1|awk '{print $7}' |cut -c 1-5`
Cpu_Perc_User=`top -l2 -F -R -u | grep "CPU usage" | tail -n1|awk '{print $3}' |cut -c 1-5`
Cpu_Perc_Sys=`top -l2 -F -R -u | grep "CPU usage" | tail -n1|awk '{print $5}' |cut -c 1-5`


## System info Battery deets 
Batt_Sysprofile_Stuff=$(system_profiler SPPowerDataType)

## Yes / No's
Batt_Pluggedin=$(echo "$Batt_Sysprofile_Stuff"|grep Connected|awk '{print $NF}')
Batt_Charging=$(echo "$Batt_Sysprofile_Stuff"|grep Charging|head -n1|awk '{print $NF}')
Batt_Charged=$(echo "$Batt_Sysprofile_Stuff"|grep Charged|awk '{print $NF}')

## Actual details 
Batt_Charge_rem=`/usr/sbin/system_profiler SPPowerDataType | grep -i "Charge remaining" | sed 's/[^0-9]//g'`
Batt_Charge_cap=`/usr/sbin/system_profiler SPPowerDataType | grep -i "Full Charge Capacity" | sed 's/[^0-9]//g'`
Batt_Cycle=`/usr/sbin/system_profiler SPPowerDataType | grep -i "Cycle Count" | sed 's/[^0-9]//g'`
Batt_rem_perc=$(echo "$Batt_Charge_rem"/"$Batt_Charge_cap"*100 | bc -l)
Batt_rem_perc=$(echo "$Batt_rem_perc" |cut -c 1-5)
Batt_rem_perc_flat=$(echo "$Batt_rem_perc" |cut -d'.' -f1)

## Level of charge in % to warn the user at.
Batt_Warn_at="11"
Batt_Warn="NO"

## If Battery drop's below 11%
if [ "$Batt_rem_perc_flat" -lt "$Batt_Warn_at" ]
then
    Batt_Warn="YES"
fi 

## Conditionals for charging status
if [[ "$Batt_Pluggedin" == "Yes" && "$Batt_Charging" == "Yes" ]] 
then
	Batt_Status="charging"
elif [[ "$Batt_Pluggedin" == "Yes" && "$Batt_Charging" == "No" &&  "$Batt_Charged" == "Yes" ]] 
then
	Batt_Status="charged"
else
	Batt_Status="draining"
fi

### Output 
echo $Batt_rem_perc","$Batt_Cycle","$Batt_Charge_cap","$Batt_Charge_rem","$Batt_Status","$Ram_Perc","$Batt_Warn","$Cpu_Load_Average","$Cpu_Perc_Free","$Cpu_Perc_User","$Cpu_Perc_Sys