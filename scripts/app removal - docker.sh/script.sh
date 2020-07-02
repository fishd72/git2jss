#!/bin/bash
#James Durler
#UC script imported by Callum Dean 12/07/2018
## Modified by D Fisher, 06/08/2018

loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

/bin/launchctl unload /Library/LaunchDaemons/com.docker.vmnetd.plist

osascript -e 'quit app "Docker"'

rm /Users/$loggedInUser/Library/Preferences/com.docker.docker.plist
rm -rf /Users/$loggedInUser/Library/Application\ Scripts/com.docker.helper/
rm -rf /Users/$loggedInUser/Library/Containers/com.docker.docker/
rm -rf /Users/$loggedInUser/Library/Group\ Containers/group.com.docker/

rm /Library/PrivilegedHelperTools/com.docker.vmnetd
rm /Library/LaunchDaemons/com.docker.vmnetd.plist
rm /usr/local/bin/com.docker.frontend
rm /usr/local/bin/vpnkit
rm /usr/local/bin/docker
rm /usr/local/bin/docker-diagnose
rm /usr/local/bin/docker-compose
rm /usr/local/bin/docker-machine
rm /usr/local/bin/docker-credential-osxkeychain
rm /usr/local/bin/notary
rm -rf /Applications/Docker.app/