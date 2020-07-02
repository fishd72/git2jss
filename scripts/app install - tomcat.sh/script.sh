#!/bin/bash

# Get the logged in users username
loggedInUser=`python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");'`

Tomcat="$4" #apache-tomcat-9.0.8


#create sysmlink for Tomcat
ln -s /usr/local/$Tomcat /Library/Tomcat

#set user permissions
chown -R $loggedInUser /Library/Tomcat

#set scripts to be exectuable by user
chmod +x /Library/Tomcat/bin/*.sh