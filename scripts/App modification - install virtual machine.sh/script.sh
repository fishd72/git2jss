#!/bin/bash

# Get the currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

srcLocation="/private/tmp/$4"
dstLocation="/Users/$loggedInUser/Parallels/$4"

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
su - $loggedInUser -c "/usr/local/bin/prlctl register \"/Users/$loggedInUser/Parallels/$4\""