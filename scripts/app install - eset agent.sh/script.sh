#!/bin/sh -e
# ESET Remote Administrator (OnlineInstallerScript)
# Copyright (c) 1992-2016 ESET, spol. s r.o. All Rights Reserved

files2del="$(mktemp -q /tmp/XXXXXXXX.files)"
dirs2del="$(mktemp -q /tmp/XXXXXXXX.dirs)"
echo "$dirs2del" >> "$files2del"
dirs2umount="$(mktemp -q /tmp/XXXXXXXX.mounts)"
echo "$dirs2umount" >> "$files2del"

finalize()
{
  set +e

  echo "Cleaning up:"

  if test -f "$dirs2umount"
  then
    while read f
    do
      sudo -S hdiutil detach "$f"
    done < "$dirs2umount"
  fi

  if test -f "$dirs2del"
  then
    while read f
    do
      test -d "$f" && rmdir "$f"
    done < "$dirs2del"
  fi

  if test -f "$files2del"
  then
    while read f
    do
      unlink "$f"
    done < "$files2del"
    unlink "$files2del"
  fi
}

trap 'finalize' HUP INT QUIT TERM EXIT

eraa_server_hostname="eset.service.dwpcloud.uk"
eraa_server_port="2222"
eraa_peer_cert_b64="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"
eraa_peer_cert_pwd=""
eraa_ca_cert_b64="MIIDITCCAgmgAwIBAgIQFgAhs/CHbK9CHbdK/Jr9rjANBgkqhkiG9w0BAQUFADApMScwJQYDVQQDEx5TZXJ2ZXIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTgwODEwMDAwMDAwWhcNMjgwODExMDAwMDAwWjApMScwJQYDVQQDEx5TZXJ2ZXIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQC6QQCM0iNVFAsWHPpCkvrEA77aLhx3ntjL2bI3ZLhHwjXDXzwbtWm04WPr1M3nQHBYba6NXzd6BP77imcEtWSAFNXs8tGApE9T0oy2NSZ2pOgsWkEMtafRWEuAYdW/wwEnGmZdVL/b/tqyVtNmr2iixwVxgN4Pla1dphTW2EfbQ17OgwHGZ+EXQOkUIFSojurb5GE1ZwxE06wrrYOjwUJ50mibC6WXBOvZJ5WPltAwWZzc9qFHIZLGwS//j3uvIw9tuzmaVekE8OZDvpNgOqDSH/hy0hcewD4yk/LFFlPBAk1eq98OpYA1fY4DuISqeXdNZe/LJfyxwTmONkXDplRzAgMBAAGjRTBDMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBRXTgJZxRDJ88v59CqT89oo/t3Y+zANBgkqhkiG9w0BAQUFAAOCAQEAJmNUCZpMZ35AcOGp0Ep6vmq+mFi1DyMcX4hMGbRzcMsuDRfm4MXSnCxL6ujCxUFU4rRzlLApsKL35VNEm0DOiNnL1Qw/NkwiV2KYXL4o4SP1RnBryGqFQBTjwvKXbqOHfBk4NTcHM7+H4IPfJJiOKv8Y9XvPSx2RpvuNvbqbSpoi72uYPPJbhYEYft7E4UI9StQ0AFvq0gWIJtIdDDBfCfO1Uq8cpFGYRJ2KI9V4JH9sZFdDhRD+ANQsXTbh47byP8AJFEF5qGHYGV1DNOoeMJ6J7r4VpF6kpsEgl6RU+Xhl8+igwRFHI3aLbc8gQGWcd7cXNl+123DshLxz42WS4g=="
eraa_product_uuid=""

eraa_installer_url="http://repository.eset.com/v1/com/eset/apps/business/era/agent/v6/6.5.376.0/agent_macosx_x86_64.dmg"
eraa_installer_checksum="9b28a28ea75d0325f1b3f56661e747bbe84ba895"
eraa_initial_sg_token="YTgxN2NlOWItZjc4Ny00NjgwLWIyODYtNjM0MWEyZDIwZjE2c3jMbh45R+Cvmtd5JjaeAcwnKtgXuEzHlo6J8Wb2ggymW5+DdCnZi6xoIa/Ddvy9qPFQCg=="

arch=$(uname -m)
if $(echo "$arch" | grep -E "^(x86_64|amd64)$" 2>&1 >> /dev/null)
then
    eraa_installer_url="http://repository.eset.com/v1/com/eset/apps/business/era/agent/v6/6.5.376.0/agent_macosx_x86_64.dmg"
    eraa_installer_checksum="9b28a28ea75d0325f1b3f56661e747bbe84ba895"
fi

if test -z $eraa_installer_url
then
  echo "No installer available for '$arch' arhitecture. Sorry :/"
  exit 1
fi

#
sleep 10
#

local_params_file="/tmp/postflight.plist"
echo "$local_params_file" >> "$files2del"

echo "<?xml version=\"1.0\" encoding=\"UTF-8\"?>" >> "$local_params_file"
echo "<!DOCTYPE plist PUBLIC \"-//Apple//DTD PLIST 1.0//EN\" \"http://www.apple.com/DTDs/PropertyList-1.0.dtd\">" >> "$local_params_file"
echo "<plist version=\"1.0\">" >> "$local_params_file"
echo "<dict>" >> "$local_params_file"

echo "  <key>Hostname</key><string>$eraa_server_hostname</string>" >> "$local_params_file"

echo "  <key>Port</key><string>$eraa_server_port</string>" >> "$local_params_file"

if test -n "$eraa_peer_cert_pwd"
then
  echo "  <key>PeerCertPassword</key><string>$eraa_peer_cert_pwd</string>" >> "$local_params_file"
  echo "  <key>PeerCertPasswordIsBase64</key><string>yes</string>" >> "$local_params_file"
fi

echo "  <key>PeerCertContent</key><string>$eraa_peer_cert_b64</string>" >> "$local_params_file"


if test -n "$eraa_ca_cert_b64"
then
  echo "  <key>CertAuthContent</key><string>$eraa_ca_cert_b64</string>" >> "$local_params_file"
fi
if test -n "$eraa_product_uuid"
then
  echo "  <key>ProductGuid</key><string>$eraa_product_uuid</string>" >> "$local_params_file"
fi
if test -n "$eraa_initial_sg_token"
then
  echo "  <key>InitialStaticGroup</key><string>$eraa_initial_sg_token</string>" >> "$local_params_file"
fi

echo "</dict>" >> "$local_params_file"
echo "</plist>" >> "$local_params_file"

# optional list of G1 migration parameters (MAC, UUID, LSID)
local_migration_list="$(mktemp -q /tmp/XXXXXXXX.migration)"
tee "$local_migration_list" 2>&1 > /dev/null << __LOCAL_MIGRATION_LIST__

__LOCAL_MIGRATION_LIST__
test $? = 0 && echo "$local_migration_list" >> "$files2del"

# get all local MAC addresses (normalized)
for mac in $(ifconfig -a | grep ether | sed -e "s/^[[:space:]]ether[[:space:]]//g")
do
    macs="$macs $(echo $mac | sed 's/\://g' | awk '{print toupper($0)}')"
done

while read line
do
  if test -n "$macs" -a -n "$line"
  then
    mac=$(echo $line | awk '{print $1}')
    uuid=$(echo $line | awk '{print $2}')
    lsid=$(echo $line | awk '{print $3}')
    if $(echo "$macs" | grep "$mac" > /dev/null)
    then
      if test -n "$mac" -a -n "$uuid" -a -n "$lsid"
      then
        /usr/libexec/PlistBuddy -c "Add :ProductGuid string $uuid" "$local_params_file"
        /usr/libexec/PlistBuddy -c "Add :LogSequenceID integer $lsid" "$local_params_file"
         break
      fi
    fi
  fi
done < "$local_migration_list"

local_dmg="$(mktemp -q -u /tmp/EraAgentOnlineInstaller.dmg.XXXXXXXX)"
echo "Downloading installer image '$eraa_installer_url':"

eraa_http_proxy_value=""
if test -n "$eraa_http_proxy_value"
then
  export use_proxy=yes
  export http_proxy="$eraa_http_proxy_value"
  (curl --connect-timeout 300 --insecure -o "$local_dmg" "$eraa_installer_url" || curl --connect-timeout 300 --noproxy "*" --insecure -o "$local_dmg" "$eraa_installer_url") && echo "$local_dmg" >> "$files2del"
else
  curl --connect-timeout 300 --insecure -o "$local_dmg" "$eraa_installer_url" && echo "$local_dmg" >> "$files2del"
fi

os_version=$(system_profiler SPSoftwareDataType | grep "System Version" | awk '{print $6}' | sed "s:.[[:digit:]]*.$::g")
if test "10.7" = "$os_version"
then
  local_sha1="$(mktemp -q -u /tmp/EraAgentOnlineInstaller.sha1.XXXXXXXX)"
  echo "$eraa_installer_checksum  $local_dmg" > "$local_sha1" && echo "$local_sha1" >> "$files2del"
  /bin/echo -n "Checking integrity of of downloaded package " && shasum -c "$local_sha1"
else
  /bin/echo -n "Checking integrity of of downloaded package " && echo "$eraa_installer_checksum  $local_dmg" | shasum -c
fi

local_mount="$(mktemp -q -d /tmp/EraAgentOnlineInstaller.mount.XXXXXXXX)" && echo "$local_mount" | tee "$dirs2del" >> "$dirs2umount"
echo "Mounting image '$local_dmg':" && sudo -S hdiutil attach "$local_dmg" -mountpoint "$local_mount" -nobrowse

local_pkg="$(ls "$local_mount" | grep "\.pkg$" | head -n 1)"

echo "Installing package '$local_mount/$local_pkg':" && sudo -S installer -pkg "$local_mount/$local_pkg" -target /