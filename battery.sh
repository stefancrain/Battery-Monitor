#!/bin/bash

#Name of the user.
name=`whoami`
#Level of charge in % to warn the user at.
warnat="11"

Ram_Total=`sysctl -n hw.memsize | awk '{print $0/1073741824}'`
Ram_Usage=`top -u -R -l1 | grep 'PhysMem' | cut -c 65-68 | awk '{print $0/1024}'`
Ram_Perc=$(echo "$Ram_Usage"/"$Ram_Total"*100 | bc -l)
Ram_Perc=$(echo "$Ram_Perc" |cut -c 1-5)

# Cpu_Load=`top -u -FR -l1 | grep 'Load Avg' | cut -c 1-27`
# Cpu_Percentage=`top -u -FR -l1 | grep 'CPU usage'`
# Cpu_Usage=`top -l 1 -F | awk '/CPU usage/' | sed "s/.*, *\([0-9.]*\)%\id.*/\1/"`


##### System info Battery deets 
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

# # if it drops below 11%
# if [ "$remperc" -lt "$warnat" ]
# fi 

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
echo $Batt_rem_perc","$Batt_Cycle","$Batt_Charge_cap","$Batt_Charge_rem","$Batt_Status","$Ram_Perc
#echo 'array("percent"=>"'$Batt_rem_perc'","cycle"=>"'$Batt_Cycle'","capacity"=>"'$Batt_Charge_cap'","remaining"=>"'$Batt_Charge_rem'","activity"=>"'$Batt_Status'","Ram_Usage"=>"'$Ram_Perc'")' 