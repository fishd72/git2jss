#!/bin/bash

while IFS=$'\n' read -r line; do javaArray+=("$line"); done < <(find $4 -name "cacerts")
util=$(find $4 -name "keytool" -maxdepth 4)
keyStorePass=changeit
certImport=/etc/ssl/certs/zscaler.pem

for keyStore in "${javaArray[@]}"
do
   echo "Modifying $keyStore"
   "$util" -import -trustcacerts -keystore "$keyStore" -storepass $keyStorePass --noprompt -alias zscaler -file $certImport ||:
done