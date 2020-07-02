#!/bin/bash

while IFS=$'\n' read -r line; do javaArray+=("$line"); done < <(find /Applications/IntelliJ* -name "cacerts")
util=$(find /Applications/IntelliJ* -name "keystore")
keyStorePass=changeit
certImport=/etc/ssl/certs/zscaler.pem

for keyStore in "${javaArray[@]}"
do
   echo "Modifying $keyStore"
   "$util" -import -trustcacerts -keystore "$keyStore" -storepass $keyStorePass --noprompt -alias zscaler -file $certImport
done