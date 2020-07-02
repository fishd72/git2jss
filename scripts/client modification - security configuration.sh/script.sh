#!/bin/bash
#
# Secure Device Script that configures initial system systems settings
#
# Requires 10.10 or higher.
#
# Compiled by Martin Bangoura
#
#
####################################################################

# Get user name and uuid
user=$( python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");' )
uuid=$( ioreg -rd1 -c IOPlatformExpertDevice | grep UUID | awk '{ print $3 }' | sed -e s/\"//g )

#<---># ============================================================================================================================ #<--->#

# Enable system and security installs

defaults write /Library/Preferences/com.apple.commerce AutoUpdate -bool TRUE
defaults write /Library/Preferences/com.apple.commerce AutoUpdateRestartRequired -bool TRUE

#<---># ============================================================================================================================ #<--->#

# Show Bluetooth status in menu bar

defaults write com.apple.systemuiserver.plist menuExtras -array-add "/System/Library/CoreServices/Menu Extras/Bluetooth.menu"

#<---># ============================================================================================================================ #<--->#

# Enable Set time and date automatically
/usr/sbin/systemsetup -settimezone "Europe/London"

cat > /etc/ntp.conf << 'NTP'
server 0.uk.pool.ntp.org
server 1.uk.pool.ntp.org
server time.euro.apple.com
NTP

/usr/sbin/systemsetup âsetusingnetworktime on

#<---># ============================================================================================================================ #<--->#

# Disable Time Machine's pop-up message whenever an external drive is plugged in
/usr/bin/defaults write /Library/Preferences/com.apple.TimeMachine DoNotOfferNewDisksForBackup -bool true

#<---># ============================================================================================================================ #<--->#

# enable location services
sudo -u _locationd defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd LocationServicesEnabled -int 1

#<---># ============================================================================================================================ #<--->#

# Restrict NTP service to loopback

# Script to configure NTP service to be restricted to loopback interface

echo -n "restrict lo interface ignore wildcard interface listen lo" >> /etc/ntp-restrict.conf

#<---># ============================================================================================================================ #<--->#

# Disable Internet Sharing

defaults write /Library/Preferences/SystemConfiguration/com.apple.nat NAT -dict-add Enabled -int 0

#<---># ============================================================================================================================ #<--->#

# Script to disable printer sharing

# Disable the printer sharing service

cupsctl --no-share-printers

# Disable for all installed printer objects

lpstat -p | awk "{print $2}"| xargs -I{} lpadmin -p {} -o printer-is-shared=false

#<---># ============================================================================================================================ #<---># -*?

# Script to disable Remote Management

/System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -deactivate -configure -access -off

#<---># ============================================================================================================================ #<---># - *?

# Script to disable "Wake on Network Access"

pmset -a womp 0


#<---># =============================================================================================================================== #<--->#

# Retain system.log for 90 days

days="90"

sed -ie 's/ttl=./ttl='$days'/' /etc/asl.conf

#<---># ============================================================================================================================== #<--->#

# Retain authd.log for 90 days

check=$( grep -i ttl /etc/asl/com.apple.authd | awk -F'ttl=' '{print $2}' )

if [ "$check" = "" ];
then
   sed -ie 's/.all_max=20M./all_max=20M\ ttl='$days'/' /etc/asl/com.apple.authd
else
   sed -ie 's/.*ttl=./ttl='$days'/' /etc/asl/com.apple.authd
fi

#<---># ============================================================================================================================== #<--->#

# Retain install.log for 365 days

days="365"
check=$( grep -i ttl /etc/asl/com.apple.install | awk -F'ttl=' '{print $2}' )

if [ "$check" = "" ];
then
   sed -ie 's/.format=bsd./format=bsd\ ttl='$days'/' /etc/asl/com.apple.install
else
   sed -ie 's/.*ttl=./ttl='$days'/' /etc/asl/com.apple.install
fi

#<---># ============================================================================================================================= #<--->#

# Disable Bonjour advertising service

defaults write /Library/Preferences/com.apple.alf globalstate -int 1

#<---># ============================================================================================================================ #<--->#

# Disable NFS service

nfsd disable
#rm /etc/export

#<---># ============================================================================================================================ #<--->#

# Secure Open Library Folders - Curtesy of Owen Pragel (owen dot pragel @ 74bit dot com)

find /Library -type d -exec chmod -R o-w {} +

#<---># ============================================================================================================================ #<--->#

# Reduce sudo timeout

# Script to set sudo timeout to zero.
# Work by Allen Golbig, all credit to him.

cp /etc/sudoers /tmp/sudoers.bak
timestamp=$(grep timestamp_timeout /tmp/sudoers.bak | cut -d '=' -f 2)

	if [ "$timestamp" = "" ]; then
		echo "Defaults timestamp_timeout=0" >> /tmp/sudoers.bak
		visudo -csf /tmp/sudoers.bak
		if [ $? -eq 0 ]; then
		        cp /tmp/sudoers.bak /etc/sudoers
		fi
	fi

	if [ "$timestamp" != "" ]; then
		sed -i "" s/"$timestamp"/0/ /tmp/sudoers.bak
		visudo -csf /tmp/sudoers.bak
		if [ $? -eq 0 ]; then
			cp /tmp/sudoers.bak /etc/sudoers
		fi
	fi

rm /tmp/sudoers.bak

#<---># ============================================================================================================================ #<--->#

# Disable shared folder access via guest
# Disable Guest User shared folder access

defaults write /Library/Preferences/com.apple.AppleFileServer guestAccess -bool no
defaults write /Library/Preferences/com.apple.smb.server AllowGuestAccess -bool no

#<---># ============================================================================================================================ #<--->#

# Remove Guest home folder
# Remove Guest User account home folder

if [ -e /Users/Guest ];
then
	rm -rf /Users/Guest
fi

#<---># ============================================================================================================================ #<--->#

# Turn on filename extensions

killall cfprefsd
defaults write NSGlobalDomain AppleShowAllExtensions -bool true

exit 0