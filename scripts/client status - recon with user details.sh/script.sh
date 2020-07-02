#!/bin/sh

# get the loggoed in or last user that logged into the computer
# lastUser=`defaults read /Library/Preferences/com.apple.loginwindow lastUserName`
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

userRealName=`dscl . -read /Users/$loggedInUser | grep RealName: | cut -c11-`
            if [[ -z $userRealName ]]; then
                userRealName=`dscl . -read /Users/$loggedInUser | awk '/^RealName:/,/^RecordName:/' | sed -n 2p | cut -c 2-`
            fi

pkgbuild --identifier uk.gov.dwp.BuildProcess-Done --nopayload "/Library/Application Support/JAMF/Receipts/BuildProcess-Done.pkg"

# echo the logged in or last user's username so it's in the policy log for error checking
# echo "$lastUser is the logged in user"
echo "$loggedInUser is the logged in user"

echo "$userRealName is the Full Name"

# submit inventory for the logged in or last user's username in the JSS
sudo jamf recon -endUsername "$loggedInUser" -realname "$userRealName"
# sudo jamf recon -realname "$userRealName"