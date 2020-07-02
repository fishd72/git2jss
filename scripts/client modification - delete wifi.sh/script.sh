#!/bin/bash

LOG_FILE="/var/log/wifi_util.log"


# Function to write to the Log file
###################################

write_log()
{
  while read text
  do
      LOGTIME=`date "+%Y-%m-%d %H:%M:%S"`
      # If log file is not defined, just echo the output
      if [ "$LOG_FILE" == "" ]; then
    echo $LOGTIME": $text";
      else
        LOG=$LOG_FILE.`date +%Y%m%d`
    touch $LOG
        if [ ! -f $LOG ]; then echo "ERROR!! Cannot create log file $LOG. Exiting."; exit 1; fi
    echo $LOGTIME": $text" | tee -a $LOG;
      fi
  done
}

echo "**********" | write_log
echo "Starting util." | write_log

## Get the wireless port ID
WirelessPort=$(networksetup -listallhardwareports | awk '/Wi-Fi|AirPort/{getline; print $NF}')

if [ -z "$WirelessPort" ]; then
    echo "No wireless adapters found." | write_log
    osascript -e 'display dialog "No wireless network adapters found." with title "DWP wireless utility" buttons {"Quit"}'
    exit 1;
fi

echo "Wireless adapter: " "$WirelessPort" | write_log

## Collect new preferred wireless network inventory and send back to the JSS
PreferredNetworks=$(networksetup -listpreferredwirelessnetworks "$WirelessPort" | sed '1d' | grep -v -E '(ENG_WIFI|CSS_WIFI)' )

OLDIFS=$IFS
IFS=$'\n'
for theNetwork in $PreferredNetworks; do
    theNetwork=${theNetwork:1}
    name=$(osascript -e 'on run argv' -e 'button returned of (display dialog item 1 of argv with title "Delete this wifi network?" buttons {"Yes", "No", "Quit"} cancel button "Quit")' -e 'end run' "$theNetwork") 2>/dev/null
    if (( $? )); then
        retainedNetworks=$(networksetup -listpreferredwirelessnetworks "$WirelessPort" | sed 's/^   //g')
        echo "User canceled run. Remaining networks below." | write_log
        echo "$retainedNetworks" | write_log
        echo "**********" | write_log
        exit 1;
    fi  # Abort, if user pressed Cancel.
    if [ $name == "Yes" ]; then
        echo "User chose to delete the wifi network: " "$theNetwork" | write_log
        networksetup -removepreferredwirelessnetwork $WirelessPort "$theNetwork" 2>/dev/null
    fi
done

retainedNetworks=$(networksetup -listpreferredwirelessnetworks "$WirelessPort" | sed 's/^   //g')

echo "Completed run. Remaining networks below." | write_log
echo "$retainedNetworks" | write_log
echo "**********" | write_log
IFS=$OLDIFS