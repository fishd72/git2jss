#!/bin/bash
#James Durler
#UC script imported by Callum Dean 12/07/2018
## Modified by D Fisher, 06/08/2018

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

osascript -e 'quit app "VisualVM"'

rm -rf /Users/$loggedInUser/Library/Caches/VisualVM/
rm -rf "/Users/$loggedInUser/Library/Application Support/VisualVM/"

rm -rf /Applications/VisualVM.app/