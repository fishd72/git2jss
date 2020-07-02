#!/bin/bash

################################
# 1Password7 Purge
# Last Updated on Nov 20th 2018
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit 1Password and the extension helper
osascript -e 'quit app "1Password 7"'
osascript -e 'quit app "1Password Extension Helper"'

#remove known locations
rm -r "/Applications/1Password 7.app/"
rm -r /Users/"$currentUser"/Library/Application\ Scripts/2BUA8C4S2C.com.agilebits.onepassword7-helper
rm -r /Users/"$currentUser"/Library/Application\ Scripts/com.agilebits.onepassword7
rm -r /Users/"$currentUser"/Library/Application\ Scripts/com.agilebits.onepassword7.1PasswordSafariAppExtension
rm -r /Users/"$currentUser"/Library/Containers/2BUA8C4S2C.com.agilebits.onepassword7-helper
rm -r /Users/"$currentUser"/Library/Containers/com.agilebits.onepassword7
rm -r /Users/"$currentUser"/Library/Group\ Containers/2BUA8C4S2C.com.agilebits
rm /private/var/db/BootCaches/0534075F-A1E3-4056-BA9A-945B064D0B3B/app.com.agilebits.onepassword7.playlist
rm /private/var/db/receipts/com.agilebits.onepassword7.bom
rm /private/var/db/receipts/com.agilebits.onepassword7.plist
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/C/2BUA8C4S2C.com.agilebits.onepassword7-helper
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/C/com.agilebits.onepassword7
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/C/com.agilebits.onepassword7.1PasswordSafariAppExtension
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/T/2BUA8C4S2C.com.agilebits.onepassword7-helper
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/T/com.agilebits.onepassword7
rm -r /private/var/folders/0m/t0fqx1wd05dfmtkjdhcl8b7c0000gn/T/com.agilebits.onepassword7.1PasswordSafariAppExtension