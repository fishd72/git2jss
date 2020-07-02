#!/bin/bash

#James Durler

#Date: 3/10/2018

#Script to automatically read the latest version of Firefox Developer , check the version on the machine and install the latest if required
#Based on Joe Farage and Deej's work to automatically update Firefox and Firefox ESR

dmgfile="FF.dmg"
logfile="/Library/Logs/FirefoxDevInstallScript.log"
lang="en-GB"

#Read latest developer edition version
latestDevVersion=`curl -s 'https://product-details.mozilla.org/1.0/firefox_versions.json' |     /usr/bin/python -c "import sys, json; print json.load(sys.stdin)['FIREFOX_DEVEDITION']"`

echo "`date`: Latest Developer Version is: $latestDevVersion" >> ${logfile}

function installFirefoxDev {

		url="https://download-installer.cdn.mozilla.net/pub/devedition/releases/${latestDevVersion}/mac/en-GB/Firefox%20${latestDevVersion}.dmg"

		echo "`date`: Download URL: $url" >> ${logfile}

		echo "`date`: Downloading newer version." >> ${logfile}
	
		/usr/bin/curl -s -o /tmp/${dmgfile} ${url}

		/bin/echo "`date`: Mounting installer disk image." >> ${logfile}

        /usr/bin/hdiutil attach /tmp/${dmgfile} -nobrowse -quiet

        /bin/echo "`date`: Checking if Firefox Developer is currently running and will kill if it is" >> ${logfile}
        firefoxid=`pgrep firefox`
		if [ -z "$firefoxid" ]
		then
    		/bin/echo "`date`: Firefox is not running, proceeding with install" >> ${logfile}
		else
    		/bin/echo "`date`: Firefix is running, killing process" >> ${logfile}
    		kill -9 $firefoxid
		fi
        /bin/echo "`date`: Installing..." >> ${logfile}
        ditto -rsrc "/Volumes/Firefox Developer Edition/Firefox Developer Edition.app" "/Applications/Firefox Developer Edition.app"
        chown -R root:wheel "/Applications/Firefox Developer Edition.app"
        /bin/sleep 5
        /bin/echo "`date`: Unmounting installer disk image." >> ${logfile}
        /usr/bin/hdiutil detach $(/bin/df | /usr/bin/grep Firefox | awk '{print $1}') -quiet
        /bin/sleep 5
        /bin/echo "`date`: Deleting disk image." >> ${logfile}
        /bin/rm /tmp/${dmgfile}
}


#Check if firefox developer is installed and if it is read the version installed locally
if [ -d /Applications/Firefox\ Developer\ Edition.app ]
then
 	echo "`date`: Firefox Developer Edition is installed" >> ${logfile}
 	#Get the version installed - remove speech marks and any commas
 	currentinstalledver=`unzip -p /Applications/Firefox\ Developer\ Edition.app/Contents/Resources/omni.ja modules/AppConstants.jsm 2>/dev/null | grep MOZ_APP_VERSION_DISPLAY | awk '{print $2}' | tr -d \" | sed 's/,/ /g'`
 	#If the version installed is equal to the latest then exit
 	if [ ${currentinstalledver} = ${latestDevVersion} ]
 	then
 		echo "`date`: Current Version: $currentinstalledver" >> ${logfile}
		echo "`date`: Firefox Developer Edition is current, exiting" >> ${logfile}
		exit 0
	#Otherwise update
	else
		/bin/echo "`date`: Latest version is not installed, installing latest version of Firefox Developer Edition" >> ${logfile}
 		installFirefoxDev	
	fi
#Otherwise install Firefox Developer Edition	
else
	echo "`date`: Firefox Developer Edition is not installed, installing now" >> ${logfile}
	installFirefoxDev
fi