#!/bin/bash

LoggedInUser=$(python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')

su - $loggedInUser -c "/Library/Application Support/JAMF/bin/jamfHelper.app/Contents/MacOS/jamfHelper" -windowType HUD -windowPosition c -title "Department for Work and Pensions - Secure Engineering Platform" -heading "You are running an outdated version of Slack" -alignHeading center -description "According to our management service, you are currently running an outdated version of the Slack application (verion 3.4.2 or below).

As Slack is primarily an online application, features may fail to work or not be available at all if you're not running the latest version.

As we switched the method of delivering the Slack application back in July, there are some manual steps we need you to take via Self Service to ensure you get the latest version of Slack, which should then keep itself up to date with fewer issues.

Please visit Self Service and run the _Remove Slack_ utility from the Uninstallers category. Once this has completed, you should be able to install the latest version of Slack, again from Self Service.

Some users have reported issues, which we are investigating, where your Mac will need to be rebooted once you've removed Slack before the installation will work. Please try this if you have issues.

Any questions, feel free to reach out in #help-macbook on DWP Digital Slack or via e-mail to support@engineering.digital.dwp.gov.uk" &