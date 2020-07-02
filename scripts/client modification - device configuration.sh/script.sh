#!/bin/bash
## postinstall

#
# FirstBoot Script that configures initial system systems settings
#
# Martin Bangoura
#
# Requires 10.10 or higher.
#
#
####################################################################

#############################
## Initial Items to setup ##
#############################

#Set hard drive name
diskutil rename / "Macintosh HD"


###############
## variables ##
###############

KEYBOARDNAME="British"                        # Keyboard name
KEYBOARDCODE="2"                              # Keyboard layout code (currently set to British)
LANG="en"                                     # macOS language
REGION="en_GB"                                # macOS region
SUBMIT_TO_APPLE=NO                            # Choose whether to submit diagnostic information to Apple
SUBMIT_TO_APP_DEVELOPERS=NO                   # Choose whether to submit diagnostic information to 3rd party developers

#### These variables can be left alone
PLBUDDY=/usr/libexec/PlistBuddy
SW_VERS=$(sw_vers -productVersion)
BUILD_VERS=$(sw_vers -buildVersion)
CRASHREPORTER_SUPPORT="/Library/Application Support/CrashReporter"
CRASHREPORTER_DIAG_PLIST="${CRASHREPORTER_SUPPORT}/DiagnosticMessagesHistory.plist"

#############################################
######## Do not edit below this line ########
#############################################

###############
## functions ##
###############

update_kdb_layout() {
  ${PLBUDDY} -c "Delete :AppleCurrentKeyboardLayoutInputSourceID" "${1}" &>/dev/null
  if [ ${?} -eq 0 ]
  then
    ${PLBUDDY} -c "Add :AppleCurrentKeyboardLayoutInputSourceID string com.apple.keylayout.${KEYBOARDNAME}" "${1}"
  fi

  for SOURCE in AppleDefaultAsciiInputSource AppleCurrentAsciiInputSource AppleCurrentInputSource AppleEnabledInputSources AppleSelectedInputSources
  do
    ${PLBUDDY} -c "Delete :${SOURCE}" "${1}" &>/dev/null
    if [ ${?} -eq 0 ]
    then
      ${PLBUDDY} -c "Add :${SOURCE} array" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0 dict" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:InputSourceKind string 'Keyboard Layout'" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:KeyboardLayout\ ID integer ${KEYBOARDCODE}" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:KeyboardLayout\ Name string '${KEYBOARDNAME}'" "${1}"
    fi
  done
}

update_language() {
  ${PLBUDDY} -c "Delete :AppleLanguages" "${1}" &>/dev/null
  if [ ${?} -eq 0 ]
  then
    ${PLBUDDY} -c "Add :AppleLanguages array" "${1}"
    ${PLBUDDY} -c "Add :AppleLanguages:0 string '${LANG}'" "${1}"
  fi
}

update_region() {
  ${PLBUDDY} -c "Delete :AppleLocale" "${1}" &>/dev/null
  ${PLBUDDY} -c "Add :AppleLocale string ${REGION}" "${1}" &>/dev/null
  ${PLBUDDY} -c "Delete :Country" "${1}" &>/dev/null
  ${PLBUDDY} -c "Add :Country string ${REGION:3:2}" "${1}" &>/dev/null
}

################
#### Script ####
################

# Change Keyboard Layout
update_kdb_layout "/Library/Preferences/com.apple.HIToolbox.plist" "${KEYBOARDNAME}" "${KEYBOARDCODE}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      HITOOLBOX_FILES=`find . -name "com.apple.HIToolbox.*plist"`
      for HITOOLBOX_FILE in ${HITOOLBOX_FILES}
      do
        update_kdb_layout "${HITOOLBOX_FILE}" "${KEYBOARDNAME}" "${KEYBOARDCODE}"
      done
    fi
done

# Set the computer language
update_language "/Library/Preferences/.GlobalPreferences.plist" "${LANG}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      GLOBALPREFERENCES_FILES=`find . -name "\.GlobalPreferences.*plist"`
      for GLOBALPREFERENCES_FILE in ${GLOBALPREFERENCES_FILES}
      do
        update_language "${GLOBALPREFERENCES_FILE}" "${LANG}"
      done
    fi
done

# Set the region
update_region "/Library/Preferences/.GlobalPreferences.plist" "${REGION}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      GLOBALPREFERENCES_FILES=`find . -name "\.GlobalPreferences.*plist"`
      for GLOBALPREFERENCES_FILE in ${GLOBALPREFERENCES_FILES}
      do
        update_region "${GLOBALPREFERENCES_FILE}" "${REGION}"
      done
    fi
done

# Disable diagnostics pop-up on 10.10 and above

if [ ! -d "${CRASHREPORTER_SUPPORT}" ]; then
  mkdir "${CRASHREPORTER_SUPPORT}"
  chmod 775 "${CRASHREPORTER_SUPPORT}"
  chown root:admin "${CRASHREPORTER_SUPPORT}"
fi

for key in AutoSubmit AutoSubmitVersion ThirdPartyDataSubmit ThirdPartyDataSubmitVersion; do
  $PLBUDDY -c "Delete :$key" "${CRASHREPORTER_DIAG_PLIST}" 2> /dev/null
done

$PLBUDDY -c "Add :AutoSubmit bool ${SUBMIT_TO_APPLE}" "${CRASHREPORTER_DIAG_PLIST}"
$PLBUDDY -c "Add :AutoSubmitVersion integer 4" "${CRASHREPORTER_DIAG_PLIST}"
$PLBUDDY -c "Add :ThirdPartyDataSubmit bool ${SUBMIT_TO_APP_DEVELOPERS}" "${CRASHREPORTER_DIAG_PLIST}"
$PLBUDDY -c "Add :ThirdPartyDataSubmitVersion integer 4" "${CRASHREPORTER_DIAG_PLIST}"

# Prevent DS_Store from being created on network shares
defaults write com.apple.desktopservices DSDontWriteNetworkStores true

#Show user Library
chflags nohidden ~/Library

#Add User to the Local Print Admin group
sudo dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin

#Disable IPv6
echo "Disabling IPv6"
networksetup -setv6off Wi-Fi >/dev/null
networksetup -setv6off Ethernet >/dev/null

#Disable Apple Application Firewall
defaults write /Library/Preferences/com.apple.alf globalstate -int 0

# Set Build Date, Version and identity in ARD Field 1, 2 & 3
#echo "Setting Build Date in ARD Field 2"
builddate=$(date "+%d-%m-%Y")
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set1 -1 "DWP EngMBPro"
sudo /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/kickstart -configure -computerinfo -set3 -3 "Built: $builddate"

exit 0		## Success
exit 1		## Failure