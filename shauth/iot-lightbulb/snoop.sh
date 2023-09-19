#!/bin/bash
#######################################################################
# This script scans channels to discover TP-Link smart bulbs
# Arguments: $1: Bulb's MAC address last byte in Hex 
# Returns time the Bulb AP is open
# Author: Sumesh Philip (sjphil3@ilstu.edu)
# Version 1.0
#######################################################################

if (( $# < 1 ));
then
	echo "Usage: snoop.sh <last-byte-of-bulb-mac>"
	exit -1;
fi

mac=$1;
mac=${mac^^};
name="TP-LINK_Smart Bulb_$mac" 
echo "Starting at $(date) and looking for $name";

str=$(wpa_cli -i wlan0 scan_results|grep -e "$name"|tr -s ' '|cut -f 5);
for (( ; ; ))
do
	if [[ ! -z $str ]];
	then
		start=$(date);
		echo $str;
		break;
	fi
	sleep 1;
	str=$(wpa_cli -i wlan0 scan_results|grep -e "$name"|tr -s ' '|cut -f 5);
#	str=$(wpa_cli -i wlan0 scan_results|grep TP-LINK|tr -s ' '|cut -f 5);
done

# Found bulb - wait for it to be off AP mode
echo "Bulb seen at $(date); watching..."

for (( ; ; ))
do
	if [[ -z $str ]];
	then
		stop=$(date);
		break;
	fi
	sleep 1;
	str=$(wpa_cli -i wlan0 scan_results|grep TP-LINK|tr -s ' '|cut -f 5);
done

echo "Bulb off of AP mode";
echo "Seen at $start";
echo "Stopped at $stop";

#Task: print the time the bulb acts as an AP
start_time=$(date -d "$start" +%s)
stop_time=$(date -d "$stop" +%s)
duration=$((stop_time - start_time))
echo "The bulb acted as an AP for $duration seconds."

exit;
