#!/bin/bash

################################
# Mozilla Firefox Purge
# Last Updated on Nov 20th 2018
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit Mozilla Firefox
osascript -e 'quit app "Microsoft Teams"'

#remove known locations
rm -r /Applications/Microsoft\ Teams.app/
rm /Library/LaunchDaemons/com.microsoft.teams.TeamsUpdaterDaemon.plist
rm /Library/Preferences/com.microsoft.teams.plist
rm -r /Users/"$currentUser"/Library/Application\ Support/Microsoft\ Teams\ Helper/
rm -r /Users/"$currentUser"/Library/Application\ Support/com.microsoft.teams/
rm -r /Users/"$currentUser"/Library/Cookies/com.microsoft.teams.binarycookies
rm -r /Users/"$currentUser"/Library/Logs/Microsoft\ Teams/
rm /Users/"$currentUser"/Library/Preferences/com.microsoft.teams.plist
rm -r /Users/"$currentUser"/Library/Saved\ Application\ State/com.microsoft.teams.savedState/
rm /var/db/receipts/com.microsoft.teams.bom
rm /var/db/receipts/com.microsoft.teams.plist