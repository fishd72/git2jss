#!/bin/bash

# erase-and-reinstall-macOS
# by Graham Pugh. 29.3.2018
#
# WARNING. This is a self-destruct script. Do not try it out on your own device!
#
# Requirements:
# macOS 10.13.4+ is already installed on the device
# Device file system is APFS

# This script downloads and runs installinstallmacos.py from Greg Neagle,
# which expects you to choose a value corresponding to the version of macOS you wish to download.
# This script automatically fills in that value so that it can be run remotely.
#
# Use Jamf Script Parameter 4 to decide which version of Install macOS app you wish to use.
# This will change in time so will always need testing.
# If you are not using Jamf, enter the value here:
installinstallmacospyValue=

if [[ ${4} && ! ${installinstallmacospyValue} ]]; then
    installinstallmacospyValue=${4}
fi

if [[ ! ${installinstallmacospyValue} ]]; then
    echo "Script cannot run without specifying a value for installinstallmacos.py. Aborting."
    echo
    exit 1
fi

# 1. Display full screen message if this screen is running on Jamf

jamfHelper="/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper"
if [[ -f "${jamfHelper}" ]]; then
#    /System/Library/CoreServices/RemoteManagement/AppleVNCServer.bundle/Contents/Support/LockScreen.app/Contents/MacOS/LockScreen &
    "${jamfHelper}" -windowType fs -title "Erasing macOS" -alignHeading center -heading "Erasing macOS" -alignDescription center -description "This computer is now being erased and is locked until rebuilt" -icon /System/Library/CoreServices/RemoteManagement/ARDAgent.app/Contents/Resources/Lock.jpg &
fi

# 2. Download installinstallmacos.py

dateTime=$( date )
workdir="/Library/Management/Jamf"

if [[ ! -d "${workdir}" ]]; then
    echo
    echo "[ ${dateTime} ] Making working directory at ${workdir}"
    echo
    mkdir -p ${workdir}
fi

if [[ ! -f "${workdir}/installinstallmacos.py" ]]; then
    curl -o ${workdir}/installinstallmacos.py -s https://raw.githubusercontent.com/munki/macadmin-scripts/master/installinstallmacos.py
fi

# 3. Use installinstallmacos.py to download the desired version of macOS

echo "[ ${dateTime} ] Running ${workdir}/installinstallmacos.py"
echo
yes ${installinstallmacospyValue} | python ${workdir}/installinstallmacos.py --workdir /Library/Management/Jamf

# 4. Mount the installer and locate the app name

macOSSparseImage=$( find ${workdir}/Install_macOS*.dmg )

existingInstaller=$( find /Volumes/Install_macOS* )
if [[ -d "${existingInstaller}" ]]; then
    disktuil unmount force "${existingInstaller}"
fi

echo "[ ${dateTime} ] Mounting ${macOSSparseImage}"
echo

hdiutil attach "${macOSSparseImage}"

installmacOSApp=$( find /Volumes/Install_macOS*/Applications/Install*.app -d -maxdepth 0 )

# 5. Run the installer
echo "[ ${dateTime} ] Running ${installmacOSApp}"
echo

#killAll LockScreen
"${installmacOSApp}/Contents/Resources/startosinstall" --applicationpath "${installmacOSApp}" --eraseinstall --agreetolicense --nointeraction