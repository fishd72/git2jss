#!/bin/bash

#function to check if pashua is installed
function pashuaInstalled {
if [ ! -d /Applications/Pashua.app ]
then
	echo "Pashua is not installed, installing now"
	jamf policy -event installPashua
	source /usr/local/scripts/pashua.sh	
else
	echo "Pashua is installed, proceeding"
	source /usr/local/scripts/pashua.sh
fi
}

# Add a text field
tx.type = textfield
tx.label = Wifi name to be removed
tx.default = Textfield content
tx.width = 310

networksetup -removepreferredwirelessnetwork en0 '$4'