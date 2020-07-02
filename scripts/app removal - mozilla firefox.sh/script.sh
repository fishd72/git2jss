#!/bin/bash

################################
# Mozilla Firefox Purge
# Last Updated on Nov 20th 2018
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit Mozilla Firefox
osascript -e 'quit app "Firefox"'

#remove known locations 
rm -r /Applications/Firefox.app/
rm -r /Users/"$currentUser"/Library/Application\ Support/Firefox/
rm -r /Users/"$currentUser"/Library/Caches/Firefox/
rm -r /Users/"$currentUser"/Library/Saved\ Application\ State/org.mozilla.firefox.savedState/
rm /Users/"$currentUser"/Library/Preferences/org.mozilla.firefox.plist
rm /var/db/receipts/org.mozilla.firefox.pkg.bom
rm /var/db/receipts/org.mozilla.firefox.pkg.plist