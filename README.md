Battery-Monitor
===============

What if you had some data to help understand what usage patterns are limiting your battery life?

## battery.sh 
- Display current battery status 
- Logs current status into a csv
- Create Usage Charts from the csv

## Terminal Output
```bash
Battery Percent:   96.66% (10832 mAh / 11206 mAh)
Battery Time:      4:13 (253 mins)
Battery Health:    Normal (865 Charges)
Battery Status:    Draining (20.8 watts)
Wifi:              On (Connected)
Display:           63%
Ram Free:          35.18% (2882 / 8192)
CPU Free:          86.82% (10.73, 2.43) 9.10, 4.24, 2.14
```

## Supported environments
- Mac 10.7.x
- Ubuntu 12.04

## Usage 
open a terminal window and change directories to the folder that contains battery.sh
```bash
cd /you/path/to/folder
```

### Check on the battery status once
```bash
./battery.sh 
```

### A battery status logger that repeats itself every 15 seconds
```bash
./battery.sh simple 
```

### Universal stress test *_not working yet_*
```bash
./battery.sh stress 
```
**You probably want to do this at a time when you won't be using your laptop**

A test of how long your battery would last a minimum by:
- Create process to use 100% of the CPU 
- Brightens the screen to 100%
- Max out Disk IO 
 - write and delete 100mb file over and over 
- Download realy 
 - 10mb file to /dev/null (wont effect hd space)
- Max out Ram buy filling it / emptying it

### Incase you forget
```bash
./battery.sh help
```


## Data Output 
### log/(YYYYMMDD).CSV stores: 
Date Nice, Epoch, Batt Cycle, Batt remaining %, Batt Charge remaining, Batt Time mins, Batt Time HH:MM, Batt AmperageMA, POWER, Batt Health, Batt Charge capacity, Batt Status, Ram Total, Ram Free, Ram Used, Ram % Free, Batt Warn Status, Cpu Load 1 min, Cpu Load 5 min, Cpu Load 15 min, Cpu % Free, Cpu % Used User, Cpu % Used Sys, Wifi Status, Wifi Connected, Ping, Display Brightnes %, exected in

### making graphs from the .csv 

![img](https://docs.google.com/spreadsheet/oimg?key=0Arqmzxm8MHGedF9fU3poOXlLVFpaUHpqcUxUc1dCWVE&oid=9&zx=pmrktv9rjvjl)
![img](https://docs.google.com/spreadsheet/oimg?key=0Arqmzxm8MHGedF9fU3poOXlLVFpaUHpqcUxUc1dCWVE&oid=10&zx=khl9e8lbqxhc)