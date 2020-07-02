#!/bin/bash

set -e

fileName=01Alias
dirName=/etc/sudoers.d/
hostName=$(scutil --get ComputerName)
userName=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

##Create the permissions file
/bin/cat << EOF > /tmp/$fileName
User_Alias USER = USERNAME
Host_Alias HOST = HOSTNAME
EOF

##Set the permission on the file just made.
/usr/sbin/chown root:wheel /tmp/$fileName
/bin/chmod 440 /tmp/$fileName

##Replace the username and hostname within the alias file with the logged in user and actual device name
sed -i '' "s/USERNAME/$userName/g" /tmp/$fileName
sed -i '' "s/HOSTNAME/$hostName/g" /tmp/$fileName

##Run check on file to ensure validity. Should quit if incorrect.
visudo -c -q -f /tmp/$fileName

##Copy the file into the Sudoers.d directory.
/bin/mv /tmp/$fileName $dirName/$fileName