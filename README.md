Battery-Monitor
===============

A Battery Monitor to chart system usage and related power drain

[Here is an interesting guide](http://support.apple.com/kb/HT1446) to maximize your battery life, but your battery display doesn't help. 


## battery.sh 
- Display current usage 
- Logs usage into a csv
- Charts usage from the csv


## Usage 

### ./battery.sh 
Check on the battery status once

### ./battery.sh simple 
A test on the battery that repeats

### ./battery.sh stress 
**You probably want to do this at a time when you won't be using your laptop**

A test of how long your battery would last a minimum by:
- Create process to use 100% of the CPU 
- Brightens the screen to 100%
- Max out Disk IO
- Download realy large file to /dev/null (wont effect hd space)
- Max out Ram

### ./battery.sh help
Incase you forget
