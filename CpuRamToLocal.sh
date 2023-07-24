#!/bin/bash

LOG_DIR="/tmp/logs"

# Create the log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Get the current date and time to use in the log file name
timestamp=$(date "+%Y%m%d%H%M%S")

LOG_FILE="$LOG_DIR/system_status_$(date '+%Y%m%d').log"

cpuuse=$(sar -P ALL 1 2 | grep 'Average.*all' | awk -F" " '{print 100.0 -$NF}')
memtotal=$(free -m | awk '/^Mem:/{print $2}')
memused=$(free -m | awk '/^Mem:/{print $3}')
memusepercent=$(awk "BEGIN {printf \"%.2f\", ${memused} / ${memtotal} * 100}")

if [ "$(echo "$cpuuse > 70" | bc -l)" -eq 1 ] || [ "$(echo "$memusepercent > 70" | bc -l)" -eq 1 ]; then
    echo "Timestamp: $timestamp" >> $LOG_FILE
    echo "CPU current usage is: $cpuuse%" >> $LOG_FILE
    echo "Memory usage is: $memusepercent%" >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "+------------------------------------------------------------------+" >> $LOG_FILE
    echo "Top 5 Processes consuming high CPU" >> $LOG_FILE
    echo "+------------------------------------------------------------------+" >> $LOG_FILE
    ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6 >> $LOG_FILE
    echo "" >> $LOG_FILE
    echo "+------------------------------------------------------------------+" >> $LOG_FILE
    echo "Top 5 Processes consuming high Memory" >> $LOG_FILE
    echo "+------------------------------------------------------------------+" >> $LOG_FILE
    ps -eo pmem,pid,user,args | sort -k 1 -r | head -6 >> $LOG_FILE
    echo "--------------------------------------------------------------------" >> $LOG_FILE
fi
