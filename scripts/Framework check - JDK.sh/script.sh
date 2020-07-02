#!/usr/bin/env bash
#######################################################################################
# Collects information to determine which version of the Java SE JDK is installed     #
# and returns that version back. SEARCH_FOR_VERSION compares major version to ensure  #
# that the major version is nine. Builds the result as MAJOR.MINOR.SECURITY			  #                                                                          #
#######################################################################################
SEARCH_FOR_VERSION="$4"
MAJOR_VERSION="-1"
RESULT="Not Installed"

installed_jdks=$(/bin/ls /Library/Java/JavaVirtualMachines/)

for i in ${installed_jdks}; do
    JAVA_VERSION=$( /usr/bin/defaults read "/Library/Java/JavaVirtualMachines/${i}/Contents/Info.plist" CFBundleVersion)
    MAJOR_VERSION=`/bin/echo $JAVA_VERSION | /usr/bin/cut -d '.' -f 1`

if [ "$MAJOR_VERSION" == "$SEARCH_FOR_VERSION" ] ; then
    RESULT="$JAVA_VERSION"
fi
done

if [ "$RESULT" = "Not Installed" ]; then
    /usr/local/bin/jamf policy -trigger JDK$4
fi