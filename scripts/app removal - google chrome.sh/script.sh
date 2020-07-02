#!/bin/bash

################################
# Google Chrome Purge
# Last Updated on Nov 17th 2016
# by Andrew Helme - www.andrewhelme.com
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit Google Chrome
osascript -e 'quit app "Google Chrome"'

#remove known locations 
rm -r /Applications/Google\ Chrome.app/
rm -r /Users/"$currentUser"/Library/Application\ Support/Google/Chrome/
rm -r /Users/"$currentUser"/Library/Saved\ Application\ State/com.google.Chrome.savedState/
rm /Users/"$currentUser"/Library/Google/GoogleSoftwareUpdate/Actives/com.google.Chrome
rm /Users/"$currentUser"/Library/Google/Google\ Chrome*
rm /Users/"$currentUser"/Library/Preferences/com.google.Chrome.plist
rm /Users/"$currentUser"/Library/Preferences/com.google.Keystone.Agent.plist