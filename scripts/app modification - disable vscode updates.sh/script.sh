#!/bin/bash

# Get the currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

dirName="/Users/$loggedInUser/Library/Application Support/Code/User"

if [ ! -d "$dirName" ]; then
    su - $loggedInUser -c "mkdir -p '$dirName'"
fi

if [ ! -f "$dirName/settings.json" ]; then
    cat > "$dirName/settings.json" <<EOF
    {
       "update.channel": "none"
       "telemetry.enableTelemetry": false,
       "telemetry.enableCrashReporter": false
    }
EOF
    chown $loggedInUser:staff "$dirName/settings.json"
fi