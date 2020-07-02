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

eraa_server_hostname="ip-172-31-32-34.eu-west-2.compute.internal"
eraa_server_port="2222"
eraa_peer_cert_b64="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"
eraa_peer_cert_pwd=""
eraa_ca_cert_b64="MIIDITCCAgmgAwIBAgIQI+UpZHEzUahAu9gfBeJJ5TANBgkqhkiG9w0BAQUFADApMScwJQYDVQQDEx5TZXJ2ZXIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwHhcNMTgwMzE4MDAwMDAwWhcNMjgwMzE5MDAwMDAwWjApMScwJQYDVQQDEx5TZXJ2ZXIgQ2VydGlmaWNhdGlvbiBBdXRob3JpdHkwggEiMA0GCSqGSIb3DQEBAQUAA4IBDwAwggEKAoIBAQCR+hTATtnKanMZWIiSQ4HLyFScGNF/StFYu+0emxojEIGoiDvZUe0Z5xQRye9pLd99D9NAEc52SyKP/xsg5GwvbnZtJOrGRrNMcU76XXDpkfFkdO1ORrRN3Q1+CXRMeifrMXG+T4YIuOKBp9tV/cyncOEbpnRU8bzH8+Ysf1nbWFxme4MafB9YN9iduwnPqtxowOEKTaWxFWywglVOm69lFxDHviTeERPnl2gGSFNtmfKnNWPxevOOIcosfWa+AM8Y+A9MpoMr6ENyH5q6EUYo2omUUgPtBestXu1FCKA5ce7zn/oIxGFIZN2+GHEzSeNdzQ5mIfOaxtbmna4nxUAlAgMBAAGjRTBDMA4GA1UdDwEB/wQEAwIBBjASBgNVHRMBAf8ECDAGAQH/AgEAMB0GA1UdDgQWBBQ/4BtHiglf1J04WepqlENDNxrD5zANBgkqhkiG9w0BAQUFAAOCAQEAbQHQ4NsGoZ6/ptd7UtGVwv+8SemB9HoiSNEoEnJ24NUfVG4Z0LodqeHoUMF+dGdA+VUE8hjZ9Y8MyYUzjxTGcMhnixcMfpM56yTfBwSX0HQ9E81V8gXuqks6x5YCL90Ne4/Yh6nr1GzkRK9OYebbGAF6tGE1zNHUaRuhrNUqqcI8vXAtf8J1/LwEKxLF1J6OX+qacMNvD7EHeXnyl4Xcgh12yFDLpx2sJQ7zqK7k4DS1uJgyHRWU2K4MW5tRGXKQQTVvSX8G+5Y2IWCpAYA1G69KeM/635UpthFuEQPE3sXInkgt3HJw3iI+c24j3gv/eqJtEitlkdaxs6e/T3n50g=="
eraa_product_uuid=""

eraa_installer_url="http://repository.eset.com/v1/com/eset/apps/business/era/agent/v6/6.5.376.0/agent_macosx_x86_64.dmg"
eraa_installer_checksum="9b28a28ea75d0325f1b3f56661e747bbe84ba895"
eraa_initial_sg_token="Y2FmOTcyZDctNDI3YS00ODA3LWIxZjUtNmE3YmE1YWEwOTBhMK/ggZZxSOaVg2uZDLVkA1vPfYKWvE2in2h3el6s72vqRcdpRNXmNHTyct2WUajqb8umHA=="

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