#!/bin/bash
#James Durler
#UC script imported by Callum Dean 12/07/2018
## Modified by D Fisher, 06/08/2018

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

osascript -e 'quit app "Pulse Secure"'
su - $loggedInUser launchctl unload /Library/LaunchAgents/net.juniper.pulsetray.plist

rm "/Library/LaunchAgents/net.juniper.pulsetray.plist"
rm -rf "/Users/$loggedInUser/Library/Caches/net.juniper.Junos-Pulse"
rm -rf "/Users/$loggedInUser/Library/Caches/net.juniper.PulseTray"
rm "/Users/$loggedInUser/Library/Saved Application State/net.juniper.PulseTray"

rm -rf "/Applications/Junos Pulse.app/"