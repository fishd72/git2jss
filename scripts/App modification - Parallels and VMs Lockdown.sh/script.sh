#!/bin/bash
## ## 
## This script locks down Parallels Desktop from being edited by standard users, as well as installed Virtual Machines preferences
## ## 
## # Lockdown Parallels Preferences for editing
sudo prlsrvctl set --lock-edit-settings on --host-admin localadmin

# Pause for two second
sleep 2

# Lockdown all installed VVMs Preferences for editing
for i in $( prlctl list -a --info | grep "ID" | sed 's/.....//;s/.$//' ); do
    prlctl set $i --lock-edit-settings on
done