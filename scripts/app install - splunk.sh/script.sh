#!/bin/bash

#### Read in the parameters
mountPoint=$1
computerName=$2
username=$3
logging=$4
password=$5

/opt/splunkforwarder/bin/splunk start
/opt/splunkforwarder/bin/splunk install app /opt/splunkforwarder/splunkclouduf.spl -auth admin:$password
/opt/splunkforwarder/bin/splunk add monitor $logging -auth admin:$password
/opt/splunkforwarder/bin/splunk restart