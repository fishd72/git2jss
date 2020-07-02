#!/bin/bash
# D Fisher, 09/07/2019

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

osascript -e 'quit app "Zoom.us"'

if [ -d /Users/"$loggedInUser"/.zoomus ]; then
    rm -rf /Users/"$loggedInUser"/.zoomus
fi
if [ -f /Users/"$loggedInUser"/Library/Preferences/us.zoom.config.plist ]; then
    rm -rf /Users/"$loggedInUser"/Library/Preferences/us.zoom.config.plist
fi
if [ -d /System/Library/Extensions/ZoomAudioDevice.kext ]; then
    rm -rf /System/Library/Extensions/ZoomAudioDevice.kext
fi
if [ -d /Users/"$loggedInUser"/Library/Application\ Support/zoom.us ]; then
    rm -rf /Users/"$loggedInUser"/Library/Application\ Support/zoom.us
fi
if [ -d /Applications/zoom.us.app ]; then
    rm -rf "/Applications/zoom.us.app/"
fi
if [ -d /Users/"$loggedInUser"/Applications/zoom.us.app ]; then
    rm -rf /Users/"$loggedInUser"/Applications/zoom.us.app/
fi