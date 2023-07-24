#!/bin/bash
cpuuse=$(sar -P ALL 1 2 | grep 'Average.*all' | awk -F" " '{print 100.0 -$NF}')
memtotal=$(free -m | awk '/^Mem:/{print $2}')
memused=$(free -m | awk '/^Mem:/{print $3}')
memusepercent=$(awk "BEGIN {printf \"%.2f\", ${memused} / ${memtotal} * 100}")
if [ "$(echo "$cpuuse > 70" | bc -l)" -eq 1 ] || [ "$(echo "$memusepercent > 70" | bc -l)" -eq 1 ]; then
    SUBJECT="ATTENTION: High CPU or Memory load on $(hostname) at $(date)"
    MESSAGE="/tmp/Mail.out"
    TO="receiver_email@ex.com"
    echo "CPU current usage is: $cpuuse%" >> $MESSAGE
    echo "Memory usage is: $memusepercent%" >> $MESSAGE
    echo "" >> $MESSAGE
    echo "+------------------------------------------------------------------+" >> $MESSAGE
    echo "Top 5 Processes consuming high CPU" >> $MESSAGE
    echo "+------------------------------------------------------------------+" >> $MESSAGE
    echo "$(ps -eo pcpu,pid,user,args | sort -k 1 -r | head -6)" >> $MESSAGE
    echo "" >> $MESSAGE
    echo "+------------------------------------------------------------------+" >> $MESSAGE
    echo "Top 5 Processes consuming high Memory" >> $MESSAGE
    echo "+------------------------------------------------------------------+" >> $MESSAGE
    echo "$(ps -eo pmem,pid,user,args | sort -k 1 -r | head -6)" >> $MESSAGE
    mail -s "$SUBJECT" "$TO" < $MESSAGE
    rm /tmp/Mail.out
fi