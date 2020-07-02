#!/bin/bash

function append() {
    eval $1[\${#$1[*]}]=$2
}

# Create array for apps to be removed
apps=()
append apps GarageBand.app
append apps iMovie.app
append apps Keynote.app
append apps Numbers.app
append apps Pages.app

for i in "${apps[@]}"
do
   if [ -d /Applications/"$i" ]; then
       rm -rf /Applications/"$i"
   fi
done