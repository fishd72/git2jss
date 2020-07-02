#!/bin/sh

LoggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
LoggedInUserHome="/Users/$LoggedInUser"

pid=$(ps -fe | grep '[f]irefox' | awk '{print $2}')
if [[ -n $pid ]]; then
    kill $pid
else
    echo "Firefox not running."
fi
if [ -e $LoggedInUserHome/Library/Caches/Mozilla/updates ];
then
    echo "Deleting updates directory"
    rm -rf $LoggedInUserHome/Library/Caches/Mozilla/updates
    else
    echo "Updates not found, skipping."
fi

exit 0