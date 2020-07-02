#!/bin/bash

# Get the currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

srcLocation="/private/tmp/"$4""
dstLocation="/Users/$loggedInUser/Parallels/"$4""

while [ ! -f $srcLocation ]
do
  sleep 2
  echo "File not landed"
done
mv "$srcLocation" "$dstLocation"
while [ ! -f $dstLocation ]
do
  sleep 2
  echo "File not moved"
done
chown -R $loggedInUser:staff "$dstLocation"
sleep 4
sudo chmod -R 755 "/Applications/Parallels Desktop.app/Contents/MacOS/prlsrvctl"
sleep 2
su - $loggedInUser -c "/usr/local/bin/prlctl register \"/Users/$loggedInUser/Parallels/$4\""
sleep 2
sudo chmod -R 754 "/Applications/Parallels Desktop.app/Contents/MacOS/prlsrvctl"