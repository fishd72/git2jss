#!/bin/sh

LoggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
LoggedInUserHome="/Users/$LoggedInUser"

echo "Logged in user is $LoggedInUser"
echo "Logged in user's home $LoggedInUserHome"

if [ -e /usr/local/bin/dockutil ];
then
    dockutilVersion=`/usr/local/bin/dockutil --version --version`; echo "dockutil version: $dockutilVersion"

    echo "Adding Self Service..."; /usr/local/bin/dockutil --add '/Applications/Self Service.app' --no-restart --replacing "Siri" "$LoggedInUserHome"
    echo "Removing Mail.app..."; /usr/local/bin/dockutil --remove 'Mail' --no-restart "$LoggedInUserHome"
    echo "Removing Calendar..."; /usr/local/bin/dockutil --remove 'Calendar' --no-restart "$LoggedInUserHome"
    echo "Removing Notes..."; /usr/local/bin/dockutil --remove 'Notes' --no-restart "$LoggedInUserHome"
    echo "Removing Contacts..."; /usr/local/bin/dockutil --remove 'Contacts' --no-restart "$LoggedInUserHome"
    echo "Removing Reminders..."; /usr/local/bin/dockutil --remove 'Reminders' --no-restart "$LoggedInUserHome"
    echo "Removing Messages..."; /usr/local/bin/dockutil --remove 'Messages' --no-restart "$LoggedInUserHome"
    echo "Removing FaceTime..."; /usr/local/bin/dockutil --remove 'FaceTime' --no-restart "$LoggedInUserHome"
    echo "Removing App Store..."; /usr/local/bin/dockutil --remove 'App Store' "$LoggedInUserHome"
else
    echo "dockutil not installed, skipping initial dock setup..."
fi

exit 0