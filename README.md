Battery-Monitor
===============

What if you had some data to help understand what usage patterns are actually limiting your battery life?

## battery.sh 
- Cross-platform *nix & Mac
- Display current usage
- Logs usage into a csv
- Charts usage from the csv


## Usage 

### ./battery.sh 
Check on the battery status once

### ./battery.sh simple 
A battery status logger that repeats itself every 15 seconds

### ./battery.sh stress 
*_not working yet_*

**You probably want to do this at a time when you won't be using your laptop**

A test of how long your battery would last a minimum by:
- Create process to use 100% of the CPU 
- Brightens the screen to 100%
- Max out Disk IO 
 - write and delete 100mb file over and over 
- Download realy 
 - 10mb file to /dev/null (wont effect hd space)
- Max out Ram buy filling it / emptying it

### ./battery.sh help
Incase you forget


### log/(YYYYMMDD).CSV stores: 
Date Nice, Epoch, Batt Cycle, Batt remaining %, Batt Charge remaining, Batt Time mins, Batt Time HH:MM, Batt AmperageMA, POWER, Batt Health, Batt Charge capacity, Batt Status, Ram Total, Ram Free, Ram Used, Ram % Free, Batt Warn Status, Cpu Load 1 min, Cpu Load 5 min, Cpu Load 15 min, Cpu % Free, Cpu % Used User, Cpu % Used Sys, Wifi Status, Wifi Connected, Ping, Display Brightnes %, exected in

### making graphs from the .csv 

![img](https://docs.google.com/spreadsheet/oimg?key=0Arqmzxm8MHGedF9fU3poOXlLVFpaUHpqcUxUc1dCWVE&oid=9&zx=pmrktv9rjvjl)
![img](https://docs.google.com/spreadsheet/oimg?key=0Arqmzxm8MHGedF9fU3poOXlLVFpaUHpqcUxUc1dCWVE&oid=10&zx=khl9e8lbqxhc)