#!/bin/bash

# Location of the VM PVS file
file="/path/to/virtual/machine/name-of.pvs"

# Grab the serial number of the local Mac
serial=`system_profiler SPHardwareDataType | awk '/Serial/ {print $4}'`

# Try not to mangle the PVS file too badly
sed -i '' "s|\(<SerialNumber>\)[^<>]*\(</SerialNumber>\)|\1${serial}\2|" $file