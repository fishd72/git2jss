#!/bin/bash
 
if [[ $(/usr/bin/id -u) -ne 0 ]]; then
     echo "Not running as root or using sudo"
     exit
fi
 
cd /private/tmp/

installer -pkg TaniumClient-7.2.314.3236.pkg -target /

rm -rf ?anium*