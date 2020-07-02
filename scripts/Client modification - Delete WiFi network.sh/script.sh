#!/bin/sh

## Get the wireless port ID
WirelessPort=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

## Run a SSID removal if its present
networksetup -removepreferredwirelessnetwork $WirelessPort $4 2>/dev/null

## Collect new preferred wireless network inventory and send back to the JSS
PreferredNetworks=$(networksetup -listpreferredwirelessnetworks "$WirelessPort" | sed 's/^   //g')

echo "<result>$PreferredNetworks</result>"