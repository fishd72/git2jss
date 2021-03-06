#!/bin/bash

# REF: https://forums.docker.com/t/feature-request-cli-tool-for-automated-installation/18334/4
# assumes the following directories exist:
# /usr/local/bin
# /Library/PrivilegedHelperTools

declare -r docker_bundle_dir=/Applications/Docker.app/Contents
declare -r privtools=/Library/PrivilegedHelperTools

for tool in com.docker.frontend docker docker-compose docker-diagnose docker-machine notary; do
    /bin/ln -sf ${docker_bundle_dir}/Resources/bin/${tool} /usr/local/bin
done

[[ ! -d ${privtools} ]] && /bin/mkdir -p ${privtools} ; /bin/chmod 1755 ${privtools}

/usr/bin/install -m 0544 -o root -g wheel ${docker_bundle_dir}/Library/LaunchServices/com.docker.vmnetd ${privtools}
/usr/bin/install -m 0644 -o root -g wheel ${docker_bundle_dir}/Resources/com.docker.vmnetd.plist /Library/LaunchDaemons

VERSION=$(/usr/bin/defaults read /Applications/Docker.app/Contents/Info.plist VmnetdVersion)
/usr/bin/defaults write /Library/LaunchDaemons/com.docker.vmnetd.plist Version -string ${VERSION}
/usr/bin/plutil -convert xml1 /Library/LaunchDaemons/com.docker.vmnetd.plist
/bin/chmod 0644 /Library/LaunchDaemons/com.docker.vmnetd.plist
/bin/launchctl load /Library/LaunchDaemons/com.docker.vmnetd.plist