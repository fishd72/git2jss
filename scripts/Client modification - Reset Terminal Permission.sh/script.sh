#!/bin/sh

# get the loggoed in or last user that logged into the computer
# lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
sudo chown $loggedInUser:staff /Users/$loggedInUser/Library/Preferences/com.apple.Terminal.plist