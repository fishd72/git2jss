#!/bin/bash

osx_vers=$(sw_vers -productVersion | awk -F "." '{print $2}')

# Check for Command line tools.
if [[ ! -f "/usr/bin/git" ]]; then
    installCommandLineTools
fi

installCommandLineTools() {
    # Installing the Xcode command line tools on 10.10+
    # This section written by Rich Trouton.
    echo "### Installing the command line tools..."
    echo
    cmd_line_tools_temp_file="/tmp/.com.apple.dt.CommandLineTools.installondemand.in-progress"

    # Installing the latest Xcode command line tools on 10.9.x or 10.10.x

    if [[ "$osx_vers" -ge 9 ]] ; then

        # Create the placeholder file which is checked by the softwareupdate tool
        # before allowing the installation of the Xcode command line tools.
        touch "$cmd_line_tools_temp_file"

        # Find the last listed update in the Software Update feed with "Command Line Tools" in the name
        cmd_line_tools=$(softwareupdate -l | awk '/\*\ Command Line Tools/ { $1=$1;print }' | tail -1 | sed 's/^[[ \t]]*//;s/[[ \t]]*$//;s/*//' | cut -c 2-)

        #Install the command line tools
        sudo softwareupdate -i "$cmd_line_tools" -v

        # Remove the temp file
        if [[ -f "$cmd_line_tools_temp_file" ]]; then
            rm "$cmd_line_tools_temp_file"
        fi
    else
        echo "Sorry, this script is only for use on OS X/macOS >= 10.9"
    fi
}