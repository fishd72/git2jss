#!/bin/sh

## Shell script for managed Apple Software Updates
## courtesy acdesigntech @ https://jamfnation.jamfsoftware.com/discussion.html?id=5404
## updated by C.Hirtle on 8/19/13
## modified by D.Fisher on 06/11/18

#### Read in the parameters
mountPoint=$1
computerName=$2
username=$3
postpones=$4            # sets number of times user can postpone updates before forcing down

fRunUpdates ()
{

    ## Once the user OKs the updates or they run automatically, reset the timer to value set above
    echo "$postpones" > /Library/Application\ Support/JAMF/.SoftwareUpdateTimer.txt

    /Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType hud -lockhud -heading 'Now installing Software Updates' -description "Software updates are currently being installed on your Mac; you may dismiss this window and continue to use your Mac normally during this process but do not restart your Mac until this is complete.

Once the updates are complete, this window will automatically close. This should take no longer than 20-30 minutes depending on the number of updates required.

If you see this screen for more than 30 minutes, please contact the project team at support@engineering.digital.dwp.gov.uk" -icon /Library/Application\ Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns > /dev/null 2>&1 &

    ## We'll need the pid of jamfHelper to kill it once the updates are complete
    JHPID=`echo "$!"`

    /usr/local/bin/jamf policy -trigger SoftwareUpdate &
    ## Get the Process ID of the last command run in the background ($!) and wait for it to complete (wait)
    SUPID=`echo "$!"`
    wait $SUPID

    ## kill the jamfHelper. If a restart is needed, the user will be prompted. If not the hud will just go away
    kill -s KILL $JHPID
    killall jamfHelper
    exit 0
}


######### Set variables for the script ############

## Get the currently logged in user, if any. Also check for updates that require a restart and ones that do not.
LoggedInUser=`who | grep console | awk '{print $1}'`
UpdatesNoRestart=`softwareupdate -l | grep recommended | grep -v restart`
RestartRequired=`softwareupdate -l | grep restart | grep -v '\*' | cut -d , -f 1`

################ End Variable Set ################

## If there are no system updates, quit
if [ "$UpdatesNoRestart" == "" -a "$RestartRequired" == "" ]; then
    echo "No updates at this time"
    exit 0
fi

## If we get to this point and beyond, there are updates. Check to see if there is a timer file on the Mac. This file tells the script how many more times it is allowed to be canceled by the user before forcing updates to install
if [ ! -e /Library/Application\ Support/JAMF/.SoftwareUpdateTimer.txt ]; then
    echo "$postpones" > /Library/Application\ Support/JAMF/.SoftwareUpdateTimer.txt
fi

## Get the timer value
Timer=`cat /Library/Application\ Support/JAMF/.SoftwareUpdateTimer.txt`

## if there is no one logged in, just run the updates
if [ "$LoggedInUser" == "" ]; then
    /usr/local/bin/jamf policy -trigger SoftwareUpdate
else
    if [ $Timer -gt 0 ]; then
            ## If someone is logged in and they have not canceled X times already, prompt them to install updates that require a restart and state how many more times they can press 'Postpone' before updates run automatically.
        if [ "$RestartRequired" != "" ]; then
            HELPER=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Library/Application\ Support/JAMF/Jamf.app/Contents/Resources/AppIcon.icns -heading "Software Updates available" -description "Software updates are available but they will require you to restart your Mac. The updates that require a restart are:

$RestartRequired

If you want to install these updates now, please click Install. To postpone installing updates to a later time, click Postpone.

You may choose to postpone the installation of these updates $Timer more times before this computer will automatically install them." -button1 "Install" -button2 "Postpone" -cancelButton "2"`
            echo "jamf helper result was $HELPER";
            ## If they click Install Updates then run the updates
            if [ "$HELPER" == "0" ]; then
                fRunUpdates
            else
            ## If no, then reduce the timer by 1. The script will run again the next day
                let CurrTimer=$Timer-1
                echo "user chose No, $CurrTimer chances left"
                echo "$CurrTimer" > /Library/Application\ Support/JAMF/.SoftwareUpdateTimer.txt
                exit 1
            fi
        fi
    ## If Timer is already 0, run the updates automatically, the user has been warned!
    else
        fRunUpdates
    fi
fi

## Install updates that do not require a restart
if [ "$UpdatesNoRestart" != "" ]; then
    /usr/local/bin/jamf policy -trigger SoftwareUpdate
fi