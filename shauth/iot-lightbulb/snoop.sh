#!/bin/bash

echo "Starting at $(date)";

str=$(wpa_cli -i wlan0 scan_results|grep TP-LINK|tr -s ' '|cut -f 5);
for (( ; ; ))
do
	if [[ ! -z $str ]];
	then
		echo $str;
		break;
	fi
	sleep 1;
	str=$(wpa_cli -i wlan0 scan_results|grep TP-LINK|tr -s ' '|cut -f 5);
done

# connect and control

echo "Bulb seen at $(date); watching..."

for (( ; ; ))
do
	if [[ -z $str ]];
	then
		echo $(date);
		break;
	fi
	sleep 1;
	str=$(wpa_cli -i wlan0 scan_results|grep TP-LINK|tr -s ' '|cut -f 5);
done

echo "Bulb off of AP mode at $(date)";
exit;
