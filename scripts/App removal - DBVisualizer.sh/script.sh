#!/bin/bash

################################
# Remove DbVisualizer
# Last Updated on Nov 20th 2018
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit 1Password and the extension helper
osascript -e 'quit app "DBVisualizer"'

#remove known locations
rm -r "/Applications/DbVisualizer.app"

pkgutil --forget com.dbvis.DbVisualizer