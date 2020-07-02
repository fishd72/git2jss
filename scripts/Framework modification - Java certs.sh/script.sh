#!/bin/bash

while IFS=$'\n' read -r line; do javaArray+=("$line"); done < <(find /Library/Java/JavaVirtualMachines/* -name "cacerts")
keyStorePass=changeit
certImport=/etc/ssl/certs/zscaler.pem

for keyStore in "${javaArray[@]}"
do
   echo "Modifying $keyStore"
   keytool -import -trustcacerts -keystore $keyStore -storepass $keyStorePass --noprompt -alias zscaler -file $certImport
done