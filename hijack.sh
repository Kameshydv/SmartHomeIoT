#!/bin/bash

if ((  $# < 3 ));
then
	echo "Usage: hijack.sh <bulb-mac> <wifi-to-join> <wifi-password>";
	exit -1;
fi

bulb=$1;
net=$2;
pass=$3;

expect ./hijack.exp $bulb $net
