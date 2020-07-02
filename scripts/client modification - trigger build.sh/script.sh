#!/bin/bash

# Function to add date to log entries
log(){
NOW="$(date +"*%Y-%m-%d %H:%M:%S")"
echo "$NOW": "$1"
}

# Logging for troubleshooting - view the log at /var/log/prefirstrun.log
touch /var/log/prefirstrun.log
exec >/var/log/prefirstrun.log 2>&1

JAMFHELPER="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"

HEADING="Department for Work and Pensions"
MESSAGE="Build in progress - Please be patient whilst we configure your device, this process should only take a few minutes.
The Department's computers are only to be used in accordance with the Department's Acceptable Use Policy. Access and use by you of this computer constitutes acceptance by you of the provisions of the Acceptable Use Policy with immediate effect."

# Disable Software Updates during DEP/enrolment
softwareupdate --schedule off
log "Software Updates disabled"

# Get the currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
log "Current user is $loggedInUser"

# get UID for current User
currentUID=$(dscl . -list /Users UniqueID | grep $loggedInUser | awk '{print $2;}')
log "$loggedInUser UID is $currentUID"

# Check and see if we're currently running as the user we want to setup - pause and wait if not
while [ $currentUID -ne 502 ] && [ $currentUID -ne 501 ]; do
    log "Currently logged in user is NOT the 501 or 502 user, waiting"
    sleep 5
    loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`
    currentUID=$(dscl . -list /Users UniqueID | grep $loggedInUser | awk '{print $2;}')
    log "Current user is $loggedInUser with UID $currentUID"
done

# Start the installation/deployment process since we're now running as the correct user.
log "501 or 502 user is now logged in, continuing setup"

# Now that that the correct user logged in - need to wait for the login to complete so it doesn't start too early
dockStatus=$(pgrep -x Dock)
log "Waiting for Desktop"
while [ "$dockStatus" == "" ]; do
  log "Desktop is not loaded, waiting"
  sleep 5
  dockStatus=$(pgrep -x Dock)
done

# Notify user of build commencement
#"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType fs -heading "Build in progress" -alignHeading center -description 'Please wait, we are configuring your device.' -alignDescription center  &
"$JAMFHELPER" -windowType fs -heading "$HEADING" -icon "/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/com.apple.macbookpro-15-retina-display.icns" -alignHeading center -description "$MESSAGE" -alignDescription center  &


# Prevent the system from sleeping
log "Preventing the Mac from sleeping during build"
caffeinate -d -i -m -u &
caffeinatepid=$!

# Set Device HostName
log "Renaming the device"
jamf policy -trigger HostnameConfiguration

# Installing Baseline Device Configurations
log "Setting baseline device controls"
jamf policy -trigger DeviceConfiguration

# Installing Baseline Security Configurations
log "Setting baseline security controls"
jamf policy -trigger SecurityConfiguration

# Installing Zscaler App
log "Installing zScaler"
jamf policy -trigger InstallzScaler

# Installing ESET Management Agent
log "Installing ESET Management Agent"
jamf policy -trigger InstallESETAgent

# Installing ESET Endpoint Security
log "Installing ESET Endpoint Security"
jamf policy -trigger InstallESET

# Configuring user dock with defaults
log "Configuring user dock with defaults"
jamf policy -trigger DockConfiguration

# Configuring device Firmware password
log "Configuring device Firmware password"
jamf policy -trigger FirmwareLock

# Eject any remaining mounted DMG Image
log "Ejecting any removable media"
osascript -e 'tell application "Finder" to eject (every disk whose ejectable is true)'

# Create BuildProcess-Done pkg
log "Build process complete, creating flag file"
jamf policy -trigger BuildComplete

# Installing Activate FileVault
log "Enabling Filevault2"
jamf policy -trigger EnableFilevault2

# Turn off sleep prevention
log "Re-enabling device power management"
kill "$caffeinatepid"

log "Terminating the jamfHelper process"
killAll jamfHelper

"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType hud -title 'DWP build notification' -heading "Build complete" -alignHeading left -description 'Your device is now configured. Please select Log Out from the Apple menu to enable disk encryption and reboot your device.' -alignDescription left -button1 "Close" -defaultButton 1 -cancelButton 1 &

exit 0