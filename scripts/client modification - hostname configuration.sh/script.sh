#!/bin/bash

SerialNumber=`/usr/sbin/system_profiler SPHardwareDataType | awk '/Serial/ { print $NF }' `

# Is this a portable? 0 = no, 1 = yes
BOOK=`/usr/sbin/system_profiler SPHardwareDataType | awk -F ": " '/Model\ Name/ { print $NF }' | grep Book | wc -l`

# Set system name variable based on the above two variables
if [ $BOOK == 1 ]
then
    NAME=DEM-$SerialNumber
else
    NAME=DEMD-$SerialNumber
fi

/usr/sbin/scutil --set ComputerName $NAME
/usr/sbin/scutil --set HostName $NAME
/usr/sbin/scutil --set LocalHostName $NAME

exit 0