#!/bin/bash

################################
# WebEx ProductivityTools Purge
# Last Updated on Jan 8th 2019
# by Dave Fisher
################################

currentUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

#quit WebEx Applications
osascript -e 'quit app "Webex Productivity Tools"'
osascript -e 'quit app "WebExPluginAgent"'

#remove known locations
Rm -r "/Library/Application Support/Microsoft/WebExPlugin/wbxPluginCore.framework"
Rm -r "/Library/Application Support/Microsoft/WebExPlugin/WebExOutlookPlugin.bundle"
Rm -r /Library/ScriptingAdditions/WebexScriptAddition.osax
Rm /Library/LaunchAgents/com.webex.pluginagent.plist
Rm /Users/"$currentUser"/Library/Preferences/com.cisco.WebEx Productivity Tools.plist
Rm /Users/"$currentUser"/Library/Logs/PT/wbxpt_01082019_120017.wbt
Rm /Users/"$currentUser"/Library/Logs/PT/wbxptSDK_01082019_120017.wbt
Rm -r /Users/Shared/WebExPlugin/WebExPluginAgent.app
Rm -r "/Applications/WebEx/Productivity Tools/"