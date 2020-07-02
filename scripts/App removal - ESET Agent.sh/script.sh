#!/bin/sh

## Stop and unload service
echo "Stoping ESET Remote Administrator Agent... "
sudo /bin/launchctl remove com.eset.remoteadministrator.agent

## Remove launchdaemons
echo "Removing LaunchDaemon... "
sudo /bin/rm "/Library/LaunchDaemons/com.eset.remoteadministrator.agent_daemon.plist"

## Call forget in pkgutil
echo "Removing from pkgutil... "
sudo /usr/sbin/pkgutil --forget com.eset.remoteadministrator.agent

## Remove ESET Remote Administrator Agent data
echo "Removing application data directory... "
sudo /bin/rm -rf "/Library/Application Support/com.eset.remoteadministrator.agent"

sleep 5

# !!! This has to be the last removal, because this script is located in this directory and sudo needs existing working directory on some versions of OS X, otherwise it will fail !!!
## Remove ESET Remote Administrator Agent
echo "Removing application directory... "
sudo /bin/rm -rf "/Applications/ESET Remote Administrator Agent.app"

sleep 10

exit 0