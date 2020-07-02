#!/bin/bash

set -e

fileName=11killdns
dirName=/etc/sudoers.d/

##Create the permissions file
/bin/cat << EOF > /tmp/$fileName
USER HOST = /usr/bin/killall -HUP mDNSResponder
EOF

##Set the permission on the file just made.
/usr/sbin/chown root:wheel /tmp/$fileName
/bin/chmod 440 /tmp/$fileName

##Run check on file to ensure validity. Should quit if incorrect.
visudo -c -q -f /tmp/$fileName

##Copy the file into the Sudoers.d directory.
/bin/mv /tmp/$fileName $dirName/$fileName