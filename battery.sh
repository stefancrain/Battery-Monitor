#!/bin/bash
# A better battery meter for everyone
unamestr=`uname`

## Level of charge in % to warn the user at.
Batt_Warn_at="11"
Batt_Warn="NO"

# min time output 
min_mins=2
min_hours=1

# set -x


if [[ "$unamestr" == 'Linux' ]]; then

    # not close to finished yet
    Top=$(top -n1)

    Cpu_Perc_Free=$(echo "$Top" | grep "Cpu(s)" | awk '{print $5}'  |sed 's/[^0-9.]//g')
    Cpu_Perc_User=$(echo "$Top" | grep "Cpu(s)" | tail -n1|awk '{print $3}' |sed 's/[^0-9.]//g')
    Cpu_Perc_Sys=$(echo "$Top" | grep "Cpu(s)" | tail -n1|awk '{print $5}' |cut -c 1-5 |sed 's/%//g')


    # extra line in the ram for ram used
    Ram_Total=`cat /proc/meminfo | grep "MemTotal:" | sed 's/kB//g' | awk '{print $NF}'`
    Ram_Free=`cat /proc/meminfo | grep "MemFree:" | sed 's/kB//g' | awk '{print $NF}'`
    Ram_Used=$(echo "$Ram_Total"-"$Ram_Free" | bc -l)

    ## Checking to see about battery status 
    Batt_Status=`cat /proc/acpi/battery/BAT0/info | grep 'charging state:' | awk '{print $NF}'`

    ## Charge details 
    Batt_Charge_rem=`cat /proc/acpi/battery/BAT0/info | grep 'last full capacity:' | sed 's/[a-z: ]\+//gI'`
    Batt_Charge_cap=`cat /proc/acpi/battery/BAT0/state | grep 'remaining capacity:' | sed 's/[a-z: ]\+//gI'`
    Batt_Cycle=`cat /proc/acpi/battery/BAT0/info | grep 'cycle count:' | sed 's/[a-z: ]\+//gI'`

elif [[ "$unamestr" == 'Darwin' ]]; then
    # Using -l2 because -l1 gave me results with higher then exected load for the 1st second, then less after that
    Top=$(top -l2 -F -R -u)
   
    Cpu_Perc_Free=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $7}' |cut -c 1-5 |sed 's/%//g')
    Cpu_Perc_User=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $3}' |cut -c 1-5 |sed 's/%//g')
    Cpu_Perc_Sys=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $5}' |cut -c 1-5 |sed 's/%//g')


    # free and used are backward here 
    Ram_Total=`sysctl -n hw.memsize | awk '{print $0/1048576}'`
    Ram_Used=$(echo "$Top" | grep 'PhysMem' | tail -n1 | awk '{print $8}'| sed 's/M//g')
    Ram_Free=$(echo "$Ram_Total"-"$Ram_Used" | bc -l)
 
    ## System info Battery deets 
    Batt_Sysprofile_Stuff=$(system_profiler SPPowerDataType)

    ## Checking to see about battery status - Yes / No's
    Batt_Pluggedin=$(echo "$Batt_Sysprofile_Stuff"|grep Connected|awk '{print $NF}')
    Batt_Charging=$(echo "$Batt_Sysprofile_Stuff"|grep Charging|head -n1|awk '{print $NF}')
    Batt_Charged=$(echo "$Batt_Sysprofile_Stuff"|grep Charged|awk '{print $NF}')


    ## Charge details 
    Batt_Charge_rem=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Charge remaining" | sed 's/[^0-9]//g')
    Batt_Charge_cap=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Full Charge Capacity" | sed 's/[^0-9]//g')
    Batt_Cycle=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Cycle Count" | sed 's/[^0-9]//g')   
    Batt_Health=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Condition" | awk '{print $NF}')   

    Batt_AmperageMA=$(echo "$Batt_Sysprofile_Stuff"|grep -i "Amperage (mA):"|awk '{print $NF}' | sed 's/[^0-9]//g')
    Batt_VoltageMV=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Voltage (mV):"|awk '{print $NF}' | sed 's/[^0-9]//g')   

    POWER=$[$Batt_AmperageMA * $Batt_VoltageMV]
    POWER=$[ $POWER / 1000000 ].$[ ($POWER % 1000000) / 100000 ]

    Batt_Time_Left=$(echo "$Batt_Charge_rem"/"$Batt_AmperageMA" |bc -l |cut -c 1-5)
    Batt_Time_Left_mins=$(echo "$Batt_Time_Left"*60 |bc -l| cut -d'.' -f1)
    Batt_Time_Left_sec=$(echo "$Batt_Time_Left"*3600 |bc -l| cut -d'.' -f1)

    hours=$[ $Batt_Time_Left_mins / 60 ]
    minutes=$[ $Batt_Time_Left_mins - ( $hours * 60) ]
    length_mins=${#minutes}
    length_hours=${#hours}

    if [[ "$length_mins" -lt "$min_mins" ]]
        then minutes="0"$minutes
    fi
    if [[ "$length_hours" -lt "$min_hours" ]]
        then hours="0"
    fi
    Batt_Time_Left_time=$(echo "$hours":"$minutes")
    
    ## Conditionals for charging status
    if [[ "$Batt_Pluggedin" == "Yes" && "$Batt_Charging" == "Yes" ]] 
    then
    	Batt_Status="Charging"
        Batt_Status_indicator='+'
    elif [[ "$Batt_Pluggedin" == "Yes" && "$Batt_Charging" == "No" &&  "$Batt_Charged" == "Yes" ]] 
    then
    	Batt_Status="Charged"
        Batt_Status_indicator=''

    else
    	Batt_Status="Draining"
        Batt_Status_indicator='-'

    fi
fi

## Process for everyone

# CPU load & usage
Cpu_Load_Average=`w | head -n1 | awk '{print $10}'` 
Date=`date +%s`

# Ram Calc
Ram_Perc_Used=$(echo "$Ram_Used"/"$Ram_Total"*100 | bc -l)
Ram_Perc_Used=$(echo "$Ram_Perc_Used" | cut -c 1-5 )
Ram_Perc_Free=$(echo "$Ram_Free"/"$Ram_Total"*100 | bc -l)
Ram_Perc_Free=$(echo "$Ram_Perc_Free" | cut -c 1-5 )

# Battery Calc
Batt_rem_perc=$(echo "$Batt_Charge_rem"/"$Batt_Charge_cap"*100 | bc -l)
Batt_rem_perc=$(echo "$Batt_rem_perc" |cut -c 1-5)
Batt_rem_perc_flat=$(echo "$Batt_rem_perc" |cut -d'.' -f1)

## If Battery drop's below xx%
if [ "$Batt_rem_perc_flat" -lt "$Batt_Warn_at" ]
then
    Batt_Warn="YES"
fi 

echo -e "\033[35mBattery Info \033[0m"
echo -e "Battery Percent:   \033[37m$Batt_rem_perc% \033[0m($Batt_Charge_rem mAh / $Batt_Charge_cap mAh)
Battery Time:      \033[37m$Batt_Time_Left_time\033[0m ($Batt_Time_Left_mins mins)
Battery Health:    \033[37m$Batt_Health\033[0m ($Batt_Cycle Charges)
Battery Status:    \033[37m$Batt_Status\033[0m ($POWER watts)
Ram Free:          \033[37m$Ram_Perc_Free%\033[0m ($Ram_Free / $Ram_Total)
CPU Free:          \033[37m$Cpu_Perc_Free%\033[0m ($Cpu_Perc_User, $Cpu_Perc_Sys) $Cpu_Load_Average"

echo $Date","$Batt_Cycle","$Batt_rem_perc","$Batt_Charge_rem","$Batt_Time_Left_mins","$Batt_Time_Left_time","$Batt_Status_indicator$Batt_AmperageMA","$POWER","$Batt_Health","$Batt_Charge_cap","$Batt_Status","$Ram_Total","$Ram_Free","$Ram_Used","$Ram_Perc_Free","$Batt_Warn","$Cpu_Load_Average","$Cpu_Perc_Free","$Cpu_Perc_User","$Cpu_Perc_Sys >> output.txt

#echo $Date","$Batt_rem_perc","$Batt_Cycle","$Batt_Charge_cap","$Batt_Charge_rem","$Batt_Status","$Ram_Total","$Ram_Used","$Ram_Perc","$Batt_Warn","$Cpu_Load_Average","$Cpu_Perc_Free","$Cpu_Perc_User","$Cpu_Perc_Sys >> output.txt
