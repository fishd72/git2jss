#!/usr/bin/env bash

consoleuser="$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')"
ZoomOpenerPID=$(lsof -ti :19421)

# Find a running ZoomOpener app and close it
if [[ -n "$ZoomOpenerPID" ]]; then
  kill -9 "$ZoomOpenerPID"
fi

# Find the ZoomOpener application and remove it
 if [[ -d /Users/"$consoleuser"/.zoomus/ZoomOpener.app ]]; then
     /bin/rm -rf /Users/"$consoleuser"/.zoomus
fi

# Prevent creation of the ZoomOpener folder
/usr/bin/touch /Users/"$consoleuser"/.zoomus