#!/bin/bash

#Nitin Pandey
#24th November 2014
#For Starting and Stopping the Kannel.
clear
cd /opt/mms/misc/kannel/gw/
echo -n "Do you want to check the status of Kannel:[y/n] :"
read File2
if [ "$File2" == 'y' ] || [ "$File2" == 'Y' ] || [ "$File2" == "yes" ] || [ "$File2" == "YES" ]; then
      File2=`ps -ef | grep kannel | grep -i box | awk '{print $2}' | wc -l`
        if [ "$File2" -eq 2 ]; then
		echo -n "Kannel is running. Please find the processID's below: "
		echo
		ps -ef | grep kannel | grep -i box
      	else 
		echo -n "Kannel is not running: "
		echo
	fi
else
	echo -n "We can go to start/stop the kannel"
fi;	

echo -n "Please choose an option to start or stop the kannel [stop/start] : "
read File1
if [ "$File1" == "stop" ]; then
         kill -9 `ps -ef | grep kannel | awk '{print $2,$8}' | grep -i box | awk '{print $1}'`
         sleep 10

elif [ "$File1" == "start" ]; then
         #kill -9 `ps -ef | grep kannel | awk '{print $2,$8}' | grep -i box | awk '{print $1}'`
         #sleep 10
         nohup ./bearerbox -v 1 smskannel.conf &
         sleep 10
         #cd sms/  Need to provide this for prodcution environment
         nohup ./smsbox -v 1 smskannel.conf & 
elif [ "$File1" != "start" ] || [ "$File1" != "Stop" ]; then     
        echo "Please provide a valid argument either start/stop" 
        exit;
fi;
ps -ef | grep kannel
