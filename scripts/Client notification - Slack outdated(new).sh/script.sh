#!/bin/bash

# get the current user
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

jhHelperApp=/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper
jhTitle="Department for Work and Pensions - Secure MacBook Service"
jhHeading="You are running an outdated version of Slack"
jhDescription="According to our management service, you are currently running an outdated version of the Slack application (verion 3.4.2 or below).

As Slack is primarily an online application, features may fail to work or not be available at all if you're not running the latest version.

As we switched the method of delivering the Slack application back in July, there are some manual steps we need you to take via Self Service to ensure you get the latest version of Slack, which should then keep itself up to date with fewer issues.

Please click the remove button below to trigger the removal of this old version, please note Slack will immediately close and be deleted. Alternatively, visit Self Service and run the _Remove Slack_ utility from the Uninstallers category. Once this has completed, you should be able to install the latest version of Slack, again from Self Service, although you might need to reboot your device first.

Any questions, feel free to reach out in #help-macbook on DWP Digital Slack or via e-mail to support@engineering.digital.dwp.gov.uk"


# test if a user is logged in
if [ -n "$loggedInUser" ]; then
    # get the uid
    uid=$(id -u "$loggedInUser")
    # do what you need to do
    #launchctl asuser "$uid" "/Library/Application Support/JAMF/bin/Management Action.app/Contents/MacOS/Management Action" -message "Please remove this legacy Slack client using Self Service."
    HELPER=`/Library/Application\ Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper -windowType utility -icon /Applications/Slack.app/Contents/Resources/slack.icns -title "$jhTitle" -alignHeading center -heading "$jhHeading" -description "$jhDescription" -button2 "Remove" -button1 "Cancel" -cancelButton "1"`

    echo "jamf helper result was $HELPER"

    if [ "$HELPER" == "0" ]; then
        echo "User clicked cancel.";
        exit 1
    else
        echo "User opted to remove Slack"
        /usr/local/bin/jamf policy -event removeSlack
        exit 0
    fi
fi