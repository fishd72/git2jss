#!/bin/bash

# Function to add date to log entries
log(){
NOW="$(date +"*%Y-%m-%d %H:%M:%S")"
echo "$NOW": "$1"
}

# Logging for troubleshooting - view the log at /var/log/prefirstrun.log
touch /var/log/prefirstrun.log
exec >/var/log/prefirstrun.log 2>&1

# Disable Software Updates during DEP/enrolment
softwareupdate --schedule off
log "Software Updates disabled"

# Prevent the system from sleeping
log "Preventing the Mac from sleeping during build"
caffeinate -d -i -m -u &
caffeinatepid=$!

#Cleanup files from prior enrollment
if [ -f /private/tmp/splash_screen.sh ];then
  echo "Removing /private/tmp/splash_screen.sh"
  rm /private/tmp/splash_screen.sh
fi
if [ -f /Library/LaunchAgents/ORG.computer_setup.plist ];then
  echo "Removing /Library/LaunchAgents/ORG.computer_setup.plist"
  rm /Library/LaunchAgents/ORG.computer_setup.plist
fi

#Get currently logged in user
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#Check for user logged in
if [[ -n $loggedInUser ]];then
    echo "$loggedInUser is logged in."
    if [[ $loggedInUser = "_mbsetupuser" ]];then
      /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType fs -heading \"Build in progress.\" -description \"Please be patient whilst we configure your device, this process should only take a few minutes.\" -icon \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/com.apple.macbookpro-15-retina-display.icns\" &
    else
      echo "Doing nothing. Exiting..."
      exit 0
    fi
fi

#Check for user not logged in
if [ -z "$loggedInUser" ];then
  #Write jamfHelper splash screen script
  echo "#!/bin/bash" >> /private/tmp/splash_screen.sh
  echo "\"/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper\" -windowType fs -heading \"Build in progress.\" -icon \"/System/Library/CoreServices/CoreTypes.bundle/Contents/Resources/com.apple.macbookpro-15-retina-display.icns\" -description \"Please be patient whilst we configure your device, this process should only take a few minutes.\"" >> /private/tmp/splash_screen.sh
  chmod +x /private/tmp/splash_screen.sh

  #Write LaunchAgent to load jamfHelper script
  defaults write /Library/LaunchAgents/ORG.computer_setup.plist Label "ORG.computer_setup"
  defaults write /Library/LaunchAgents/ORG.computer_setup.plist LimitLoadToSessionType "LoginWindow"
  defaults write /Library/LaunchAgents/ORG.computer_setup.plist ProgramArguments -array
  defaults write /Library/LaunchAgents/ORG.computer_setup.plist KeepAlive -bool true
  defaults write /Library/LaunchAgents/ORG.computer_setup.plist RunAtLoad -bool true
  /usr/libexec/PlistBuddy -c "Add ProgramArguments: string /private/tmp/splash_screen.sh" /Library/LaunchAgents/ORG.computer_setup.plist

  chown root:wheel  /Library/LaunchAgents/ORG.computer_setup.plist
  chmod 644 /Library/LaunchAgents/ORG.computer_setup.plist
  echo "Created Launch Agent to run jamfHelper"

  #Kill/restart the loginwindow process to load the LaunchAgent
  echo "Ready to lock screen. Restarting loginwindow process..."
  kill -9 $(ps axc | awk '/loginwindow/{print $1}')
fi

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

# Configuring device Firmware password
log "Configuring device Firmware password"
jamf policy -trigger FirmwareLock

# Install NoMAD products
log "Installing NoMAD Login+, NoMAD Pro and the NoMAD Pro launchagent"
jamf policy -trigger NoMADLogin

# Create BuildProcess-Done pkg
log "Build process complete, creating flag file"
jamf policy -trigger BuildComplete


# Turn off sleep prevention
log "Re-enabling device power management"
kill "$caffeinatepid"

# Kill the build notification and trigger NoMAD Login+
log "Terminating the jamfHelper process"
if [ -f /private/tmp/splash_screen.sh ];then
  echo "Removing /private/tmp/splash_screen.sh"
  rm /private/tmp/splash_screen.sh
fi
if [ -f /Library/LaunchAgents/ORG.computer_setup.plist ];then
  echo "Removing /Library/LaunchAgents/ORG.computer_setup.plist"
  rm /Library/LaunchAgents/ORG.computer_setup.plist
fi

ps axco pid,command | grep jamfHelper | awk '{ print $1; }' | xargs kill -9
/usr/bin/killall -9 loginwindow

exit 0