#!/bin/bash

################################
# Mozilla Firefox Purge
# Last Updated on Nov 20th 2018
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit Mozilla Firefox
osascript -e 'quit app "IntelliJ IDEA CE"'

#remove known locations
rm -r /Applications/IntelliJ\ IDEA\ CE.app/
rm /Users/"$currentUser"/Library/Preferences/com.jetbrains.intellij.ce.plist
rm -r /Users/"$currentUser"/Library/Saved\ Application\ State/com.jetbrains.intellij.ce.savedState/
rm /var/db/receipts/com.jetbrains.intellij.ce.bom
rm /var/db/receipts/com.jetbrains.intellij.ce.plist