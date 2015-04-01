#!/bin/bash
# A better battery meter for everyone
# Stefan Crain (stefancrain@gmail.com)


OperatingSystem=`uname`

## Level of charge in mins to warn the user at.
Batt_Warn_at="11"
Batt_Warn="OK"

# vars for gloabl quick functions
Clear=`clear`
Here=`pwd`

#   # functions area

function battery_setup {
    # Setup things for the script
    mkdir logs
}

function battery_getStatus {
    # start timer
    start_time=`date +%s`

    # *nix or Mac
    if [[ "$OperatingSystem" == 'Linux' ]]; then

        Top=$(top -n1)

        Cpu_Perc_Free=$(echo "$Top" | grep "Cpu(s)" | awk '{print $5}'  |sed 's/[^0-9.]//g')
        Cpu_Perc_User=$(echo "$Top" | grep "Cpu(s)" | tail -n1|awk '{print $3}' |sed 's/[^0-9.]//g')
        Cpu_Perc_Sys=$(echo "$Top" | grep "Cpu(s)" | tail -n1|awk '{print $5}' |cut -c 1-5 |sed 's/%//g')

        # Display
        Display_Brightnes=$( cat /proc/acpi/video/VGA/LCD/brightness | awk '{print $NF}')
        # Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l)
        Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l|cut -d'.' -f1)
        if [[ "$Display_Brightnes_perc" == "0" ]]
            then Display_Brightnes_perc="0"
        fi

        # Wifi
        Wifi_Status=$(lshw -C network | grep -E '(description: Wireless interface)' echo Connected ||  echo No connection)
        # Wifi_device=$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")
        # Wifi_Status=$(networksetup -getairportpower "$Wifi_device"| awk '{print $NF}')
        # Wifi_Connected=`networksetup -getinfo Wi-Fi | grep -c 'IP address:'` # 1 = no connection, 2 = connected to network
        # Ping=`curl -s www.google.com > /dev/null &&  echo Connected ||  echo No connection` # not really a ping
        Ping=`wget -q -T1 www.google.com > /dev/null &&  echo Connected ||  echo No connection` # not really a ping

        # extra line in the ram for ram used
        Ram_Total=`cat /proc/meminfo | grep "MemTotal:" | sed 's/kB//g' | awk '{print $NF}'`
        Ram_Free=`cat /proc/meminfo | grep "MemFree:" | sed 's/kB//g' | awk '{print $NF}'`
        Ram_Used=$(echo "$Ram_Total"-"$Ram_Free" | bc -l)

        # Display
        Display_Brightnes=$(cat /proc/acpi/video/VGA/LCD/brightness | awk '{print $NF}')
        # Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l)
        Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l|cut -d'.' -f1)
        if [[ "$Display_Brightnes_perc" == "0" ]]
            then Display_Brightnes_perc="0"
        fi

        # Grab the battery
        Batt_List=`ls /proc/acpi/battery/`;

        for Batt in $Batt_List;do

            ## Checking to see about battery status - Yes / No's
            Batt_Status=`cat /proc/acpi/battery/$Batt/{info,state}|grep "charging state:" |grep -o "[a-z]\+$"`

            ## Charge details
            Batt_Charge_rem=`cat /proc/acpi/battery/$Batt/{info,state}|grep remaining|grep -o "[0-9]\+"`
            Batt_Charge_cap=`cat /proc/acpi/battery/$Batt/{info,state}|grep full |grep -o "[0-9]\+"`
            Batt_Cycle=`cat /proc/acpi/battery/$Batt/info | grep 'cycle count:' | sed 's/[a-z: ]\+//gI'`
            Batt_Health=`cat /proc/acpi/battery/$Batt/{info,state}|grep "capacity state:" |grep -o "[a-z]\+$"`

            #descap=`cat /proc/acpi/battery/$Batt/{info,state}|grep "design capacity:" |grep -o "[0-9]\+"`
            Batt_AmperageMA=`cat /proc/acpi/battery/$Batt/{info,state}|grep "present rate:" |grep -o "[0-9]\+"`
            Batt_VoltageMV=`cat /proc/acpi/battery/$Batt/{info,state}|grep "present voltage:" |grep -o "[0-9]\+"`

            ## Conditionals for charging status
            if [[ "$Batt_Status" == "charging" ]]
                then Batt_Status_indicator='+'
            elif [[ "$Batt_Status" == "discharging" ]]
                then Batt_Status_indicator='-'
            else
                 Batt_Status_indicator=''
            fi
        done

    elif [[ "$OperatingSystem" == 'Darwin' ]]; then
        # Using -l2 because -l1 gave me results with higher then exected load for the 1st second, then less after that
        Top=$(top -l2 -F -R -u)

        # CPU info
        # not used - top -l2 -F -R  | grep -E 'CPU usage' | tail -n1 | grep -o ".....%" | sed 's/[^0-9.]//g'
        Cpu_Perc_Free=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $7}' |cut -c 1-5 |sed 's/%//g')
        Cpu_Perc_User=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $3}' |cut -c 1-5 |sed 's/%//g')
        Cpu_Perc_Sys=$(echo "$Top" | grep "CPU usage" | tail -n1|awk '{print $5}' |cut -c 1-5 |sed 's/%//g')

        # Display
        Display_Brightnes=$( "$Here"/brightness -l |grep brightness|awk '{print $NF}')
        # Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l)
        Display_Brightnes_perc=$(echo "$Display_Brightnes"*100 | bc -l|cut -d'.' -f1)
        if [[ "$Display_Brightnes_perc" == "0" ]]
            then Display_Brightnes_perc="0"
        fi

        # Wifi
        Wifi_device=$(networksetup -listallhardwareports | grep -E '(Wi-Fi|AirPort)' -A 1 | grep -o "en.")
        Wifi_Status=$(networksetup -getairportpower "$Wifi_device"| awk '{print $NF}')
        Wifi_Connected=`networksetup -getinfo Wi-Fi | grep -c 'IP address:'` # 1 = no connection, 2 = connected to network
        Ping=`curl -s www.google.com > /dev/null &&  echo Connected ||  echo No connection` # not really a ping

        # Ram Usage
        Ram_Total=`sysctl -n hw.memsize | awk '{print $0/1048576}'`
        Ram_Used=$(echo "$Top" | grep 'PhysMem' | tail -n1 | awk '{print $6}'| sed 's/M//g')
        Ram_Free=$(echo "$Ram_Total"-"$Ram_Used" | bc -l)

        ## System info Battery deets
        Batt_Sysprofile_Stuff=$(system_profiler SPPowerDataType)

        ## Checking to see about battery status - Yes / No's
        Batt_Pluggedin=$(echo "$Batt_Sysprofile_Stuff"|grep Connected|awk '{print $NF}')
        Batt_Charging=$(echo "$Batt_Sysprofile_Stuff"|grep Charging|head -n1|awk '{print $NF}')
        Batt_Charged=$(echo "$Batt_Sysprofile_Stuff"|grep -i "Fully Charged"|awk '{print $NF}')

        ## Charge details
        Batt_Charge_rem=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Charge remaining" | sed 's/[^0-9]//g')
        Batt_Charge_cap=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Full Charge Capacity" | sed 's/[^0-9]//g')
        Batt_Cycle=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Cycle Count" | sed 's/[^0-9]//g')
        Batt_Health=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Condition" | awk '{print $NF}')

        Batt_AmperageMA=$(echo "$Batt_Sysprofile_Stuff"|grep -i "Charge Remaining (mAh):"|awk '{print $NF}' | sed 's/[^0-9]//g')
        Batt_VoltageMV=$(echo "$Batt_Sysprofile_Stuff" | grep -i "Voltage (mV):"|awk '{print $NF}' | sed 's/[^0-9]//g')

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

    ## Calcumations for everyone

    # CPU load & usage
    Cpu_Load_Average1=`uptime | awk '{print $(NF-2)}'`
    Cpu_Load_Average5=`uptime | awk '{print $(NF-1)}'`
    Cpu_Load_Average15=`uptime | awk '{print $NF}'`

    Date_Epoch=`date +%s`
    Date_Nice=`date -r $Date_Epoch +%Y%/%m%/%d%" "%H%:%M%:%S`
    Date_Short=`date -r $Date_Epoch +%Y%m%d`

    # Ram Calc
    Ram_Perc_Used=$(echo "$Ram_Used"/"$Ram_Total"*100 | bc -l)
    Ram_Perc_Used=$(echo "$Ram_Perc_Used" | cut -c 1-5 )
    Ram_Perc_Free=$(echo "$Ram_Free"/"$Ram_Total"*100 | bc -l)
    Ram_Perc_Free=$(echo "$Ram_Perc_Free" | cut -c 1-5 )

    # Battery Calc
    POWER=$[$Batt_AmperageMA * $Batt_VoltageMV]
    POWER=$[ $POWER / 1000000 ].$[ ($POWER % 1000000) / 100000 ]

    Batt_Time_Left=$(echo "$Batt_Charge_rem"/"$Batt_AmperageMA" |bc -l |cut -c 1-5)
    Batt_Time_Left_mins=$(echo "$Batt_Time_Left"*60 |bc -l| cut -d'.' -f1)
    Batt_Time_Left_sec=$(echo "$Batt_Time_Left"*3600 |bc -l| cut -d'.' -f1)

    Batt_rem_perc=$(echo "$Batt_Charge_rem"/"$Batt_Charge_cap"*100 | bc -l)
    Batt_rem_perc=$(echo "$Batt_rem_perc" |cut -c 1-5)
    Batt_rem_perc_flat=$(echo "$Batt_rem_perc" |cut -d'.' -f1)
    hours=$[ $Batt_Time_Left_mins / 60 ]
    minutes=$[ $Batt_Time_Left_mins - ( $hours * 60) ]

    if [[ ${#minutes} -lt 2 ]]
    then minutes="0"$minutes
    fi
    if [[ ${#hours} -lt 1 ]]
    then hours="0"
    fi
    Batt_Time_Left_time=$(echo "$hours":"$minutes")

    ## If Battery drop's below xx mins
    if [[ "$Batt_Time_Left_mins" -lt "$Batt_Warn_at" && Batt_Status -eq "Draining" ]]
    then
        Batt_Warn="WARN"
    fi

    # calculate time
    end_time=`date +%s`
    executed_in=$[ $end_time - $start_time ]
 }

function battery_getStatusSimple {
    while [ 0 -le 1 ]
    do
        battery_getStatus
        echo $Clear
        battery_output
        battery_log
        # loop every 15 seconds
        sleep $[ 15- $executed_in ]
    done
}

function battery_getStatusJSON {
  # no loop, run once
    battery_getStatus
    echo $Date_Nice","$Date_Epoch","$Batt_Cycle","$Batt_rem_perc","$Batt_Charge_rem","$Batt_Time_Left_mins","$Batt_Time_Left_time","$Batt_Status_indicator$Batt_AmperageMA","$POWER","$Batt_Health","$Batt_Charge_cap","$Batt_Status","$Ram_Total","$Ram_Free","$Ram_Used","$Ram_Perc_Free","$Batt_Warn","$Cpu_Load_Average1","$Cpu_Load_Average5","$Cpu_Load_Average15","$Cpu_Perc_Free","$Cpu_Perc_User","$Cpu_Perc_Sys","$Wifi_Status","$Wifi_Connected","$Ping","$Display_Brightnes_perc","$executed_in
}

function battery_getStatusStress {

  # Get CPU count
  if [[ "$OperatingSystem" == 'Linux' ]]; then
    Cpu_Count=`grep -c 'model name' /proc/cpuinfo`
  elif [[ "$OperatingSystem" == 'Darwin' ]]; then
    Cpu_Count=`sysctl hw.ncpu | awk '{print $2}'`
  fi

    # Max out ALL of the CPU's
  num=0
  while [ $Cpu_Count -le $num ]
    do
      yes > /dev/null
    $num++
    done

  # Every 15 seconds, until we kill it.
    while [ 0 -le 1 ]
    do


    if [[ "$OperatingSystem" == 'Linux' ]]; then

      # set the brightness to 100 %
      echo 100 > /proc/acpi/video/VGA/LCD/brightness # - *nix

      # http://pastebin.com/u7Phms1m
      # dd if=/dev/zero of=/tmp/test.file bs=1M count=1000
      # for i in {1..5}; do md5sum /tmp/test.file; done

    elif [[ "$OperatingSystem" == 'Darwin' ]]; then
      #clear ram
      purge

      # set the brightness to 100 %
      $Here/brightness 1.0
    fi
    # normal logging
        battery_getStatus
        echo $Clear
        battery_output
        battery_log

        # loop every 15 seconds
        sleep $[ 15- $executed_in ]
    done
}
function battery_getStatusStress_Stop {
  # Kill whatever stress tests we've started
    :
}

function battery_output {
    echo "Battery Percent:   $Batt_rem_perc% ($Batt_Charge_rem mAh / $Batt_Charge_cap mAh)
Battery Time:      $Batt_Time_Left_time ($Batt_Time_Left_mins mins)
Battery Health:    $Batt_Health ($Batt_Cycle Charges)
Battery Status:    $Batt_Status ($POWER watts)
Wifi:              $Wifi_Status ($Ping)
Display:           $Display_Brightnes_perc%
Ram Free:          $Ram_Perc_Free% ($Ram_Free / $Ram_Total)
CPU Free:          $Cpu_Perc_Free% ($Cpu_Perc_User, $Cpu_Perc_Sys) $Cpu_Load_Average1, $Cpu_Load_Average5, $Cpu_Load_Average15"
}

function battery_log {
    # if were writing for the first time, lets add some columns to the csv
    if [ -f logs/$Date_Short.csv ]
    then
        echo $Date_Nice","$Date_Epoch","$Batt_Cycle","$Batt_rem_perc","$Batt_Charge_rem","$Batt_Time_Left_mins","$Batt_Time_Left_time","$Batt_Status_indicator$Batt_AmperageMA","$POWER","$Batt_Health","$Batt_Charge_cap","$Batt_Status","$Ram_Total","$Ram_Free","$Ram_Used","$Ram_Perc_Free","$Batt_Warn","$Cpu_Load_Average1","$Cpu_Load_Average5","$Cpu_Load_Average15","$Cpu_Perc_Free","$Cpu_Perc_User","$Cpu_Perc_Sys","$Wifi_Status","$Wifi_Connected","$Ping","$Display_Brightnes_perc","$executed_in >> logs/$Date_Short.csv
    else
        mkdir -p logs/
        echo " Date Nice, Epoch, Batt Cycle, Batt % remaining, Batt Charge remaining, Batt Time mins, Batt Time HH:MM, Batt AmperageMA, POWER Draw W, Batt Health, Batt Charge capacity, Batt Status, Ram Total, Ram Free, Ram Used, Ram % Free, Batt Warn Status, Cpu Load 1 min, Cpu Load 5 min, Cpu Load 15 min, Cpu % Free, Cpu % Used User, Cpu % Used Sys, Wifi Status, Wifi Connected, Ping, Display Brightnes %, executed in"  > logs/$Date_Short.csv
        battery_log
    fi
}

# Start main program
function battery_help {
    echo ""
    echo -n "$0"
    echo     " - Runs the Battery Logger once"
    echo -n "$0"
    echo -ne "\033[36m JSON\033[0m"
    echo     " - Runs the Battery Logger once Returns JSON encoded array"
    echo -n "$0"
    echo -ne "\033[36m simple\033[0m"
    echo     " - Runs a battery logger"
    echo -n "$0"
    echo -ne "\033[36m stress\033[0m"
    echo     " - Stresses your computer and logs the battery reaction"
    echo ""
    exit
}

case $1 in
'')
    battery_getStatus
    battery_output
    ;;
simple)
    battery_getStatusSimple
    ;;
JSON)
  battery_getStatusJSON
  ;;
stress)
    battery_getStatusStress
    ;;
help)
    battery_help
    ;;
esac
