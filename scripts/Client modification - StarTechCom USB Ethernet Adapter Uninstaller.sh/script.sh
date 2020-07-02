#!/bin/sh

KEXT_PATH_ETH_108_179=/System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/AX88179.kext
KEXT_PATH_ETH_108=/System/Library/Extensions/IONetworkingFamily.kext/Contents/PlugIns/AX88179_178A.kext
KEXT_PATH_ETH_109=/Library/Extensions/AX88179_178A.kext

echo "AX88179_178A_Uninstall_v150"

if [ -e $KEXT_PATH_ETH_108_179 ]; then
	sudo kextunload "$KEXT_PATH_ETH_108_179"
	sudo rm -rf "$KEXT_PATH_ETH_108_179"
fi

if [ -e $KEXT_PATH_ETH_108 ]; then
	sudo kextunload "$KEXT_PATH_ETH_108"
	sudo rm -rf "$KEXT_PATH_ETH_108"
fi

if [ -e $KEXT_PATH_ETH_109 ]; then
	sudo kextunload "$KEXT_PATH_ETH_109"
	sudo rm -rf "$KEXT_PATH_ETH_109"
fi

pkgutil --pkgs| grep 'AX88179.pkg' &> /dev/null
if [ $? == 0 ]; then
   sudo pkgutil --forget AX88179.pkg
fi

pkgutil --pkgs| grep 'AX88179_178A.pkg' &> /dev/null
if [ $? == 0 ]; then
   sudo pkgutil --forget AX88179_178A.pkg
fi

pkgutil --pkgs| grep 'com.asix.tw.ax88179_178a' &> /dev/null
if [ $? == 0 ]; then
   sudo pkgutil --forget com.asix.tw.ax88179_178a
fi

pkgutil --pkgs| grep 'com.asix.pkg.ax88179-178a-10.8' &> /dev/null
if [ $? == 0 ]; then
   sudo pkgutil --forget com.asix.pkg.ax88179-178a-10.8
fi

pkgutil --pkgs| grep 'com.asix.pkg.ax88179-178a-10.9' &> /dev/null
if [ $? == 0 ]; then
   sudo pkgutil --forget com.asix.pkg.ax88179-178a-10.9
fi

sudo touch /System/Library/Extensions/
sudo touch /Library/Extensions/