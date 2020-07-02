#!/bin/bash
#James Durler
#UC script imported by Callum Dean 12/07/2018
## Modified by D Fisher, 06/08/2018

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

osascript -e 'quit app "VMware View Client"'

rm /Users/$loggedInUser/Library/Preferences/com.vmware.view.plist
rm -rf "/Users/$loggedInUser/Library/Logs/VMware View Client/"

rm /private/var/folders/cv/3tgt0__n53v931qcjz547dwc0000gp/C/com.vmware.view

rm -rf "/Applications/VMware View Client.app/"