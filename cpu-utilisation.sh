#!/bin/bash

	#Author: Nitin Pandey

	#Purpose: To monitor the CPU usage

	#Date:2016-01-20

	SUBJECT="CanalPlus Application Layer Report"

	TO=nitin@

        rm -rf /home/mms/scripts/messages
	
	SERVERSTATS=/home/mms/scripts/messages

	echo "#######################" >> $SERVERSTATS

        echo "Load on the system" >> $SERVERSTATS

        tail -n 70 /home/alex.log >> $SERVERSTATS

        echo "#######################" >> $SERVERSTATS
 
        echo "CPU statistics as follows" >> $SERVERSTATS

        echo "CPU during 30 seconds" >> $SERVERSTATS
        
        sar 1 30 >> $SERVERSTATS

        echo "CPU evolution during the day" >> $SERVERSTATS

        sar >> $SERVERSTATS

        echo "#######################" >> $SERVERSTATS

        echo "Memory statistics as follows" >> $SERVERSTATS

        ps -eo pmem,pcpu,vsize,pid,cmd | sort -k 1 -nr | head -7 >> $SERVERSTATS

        echo "#######################" >> $SERVERSTATS

        echo "Network statistics as follows" >> $SERVERSTATS

        netstat -nap | awk '/tcp/ {print $6}'| sort | uniq -c >> $SERVERSTATS

        echo "#######################" >> $SERVERSTATS

        echo "Netstat statisctics as follows" >> $SERVERSTATS

        netstat -an >> $SERVERSTATS

        echo "#######################"  >> $SERVERSTATS

	mail -s "$SUBJECT" "$TO" "@com" < $SERVERSTATS
