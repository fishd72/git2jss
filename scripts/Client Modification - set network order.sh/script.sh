#!/bin/bash

#author: James Durler
#amended to comment out IP V6 enforcement & changed the order to prioritise WiFi over Ethernet.

#Standard Network Profile Script
#1 - Sets the service order for a particular machine
#  - Evaluates what ethernet devices, wifi devices and everything else the machine has
#  - and then does some magic and priortises WiFi -> Ethernet -> Everything else

#2 - Disables IPV6 - This for some reason can turn itself back on - potentially OS updates may be doing this
#  - this script just redisables IPV6 on ANY enabled interface

#This script will be run on a daily basis to ensure the correct service order is maintained and IPV6 is disabled

#reprograms IFS so it doesn't treat spaces as new items
IFS=$'\n'

#set the service order to ethernet devices at the top and then WiFi devices and then everything else that is no ethernet or wifi follows

#put all ethernet devices in array and sort alphabetically
ethernetDevices=(`networksetup -listnetworkserviceorder | cut -d')' -f2 | sed '/^$/d' | sed '1d' | grep "Ethernet" | sort`)

#put all wifi devices in array and sort alphabetically
wifiDevices=(`networksetup -listnetworkserviceorder | cut -d')' -f2 | sed '/^$/d' | sed '1d' | grep "Wi-Fi" | sort`)

#put all other devices excluding ethernet and wifi in array
otherDevices=(`networksetup -listnetworkserviceorder | cut -d')' -f2 | sed '/^$/d' | sed '1d' | grep -v "Ethernet" | grep -v "Wi-Fi"`)

#initialise i as 0
i=0
for device in ${ethernetDevices[@]}
do
	#remove the blank space at the start of the variable
	device=$(echo $device | cut -c 2-)
	#add speech marks to each adapter so we can execute the service order command later
	ethernetDevices[i]=$(echo "\"$device\"")
	let i=i+1
done

#reinitialise i to 0
i=0
for device in ${wifiDevices[@]}
do
	#remove the blank space at the start of the variable
	device=$(echo $device | cut -c 2-)
	#add speech marks to each adapter so we can execute the service order command later
	wifiDevices[i]=$(echo "\"$device\"")
	let i=i+1
done

#reinitialise i to 0
i=0
for device in ${otherDevices[@]}
do
	#remove the blank space at the start of the variable
	device=$(echo $device | cut -c 2-)
	#add speech marks to each adapter so we can execute the service order command later
	otherDevices[i]=$(echo "\"$device\"")
	let i=i+1
done


ethList=$(echo ${ethernetDevices[@]})

wifiList=$(echo ${wifiDevices[@]})

otherDevicesList=$(echo ${otherDevices[@]})

commandToRun=$(echo "/usr/sbin/networksetup -ordernetworkservices $wifiList $ethList $otherDevicesList")

#execute the networksetup command
eval $commandToRun


#loop through the network interfaces and dsiable accordingly - exclude disabled services and by excluding * it will also exclude the top line
#from listallnetworkservices which doesn't include any interface names 

#for interface in $(networksetup -listallnetworkservices | grep -v "*")
#do
#	echo "Disabling IPV6 on $interface"
#	networksetup -setv6off "$interface"
#done

 unset IFS