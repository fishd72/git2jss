#!/bin/bash
#
#
# Get the currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

# Location of the VM PVS file - can pass as a Jamf script variable
file="/Users/$loggedInUser/Parallels/"$4"/config.pvs"

# Grab the serial number of the local Mac
serial=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`

# Try not to mangle the PVS file too badly
sed -i '' "s|\(<SerialNumber>\)[^<>]*\(</SerialNumber>\)|\1${serial}\2|" "$file"