#!/bin/sh

compName=$(scutil --get ComputerName)
acctName="billybob"    ## You will need the shortname of the account, so all lowercase presumably
suffix="_i_forgot_my_password"

dscl . passwd /Users/$acctName "$compName$suffix"

if [ $? == 0 ]; then
    echo "Password successfully changed"
else
    echo "Password not changed"
fi

exit