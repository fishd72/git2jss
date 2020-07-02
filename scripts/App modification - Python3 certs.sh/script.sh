#!/bin/bash

DIRECTORY=/Library/Frameworks/Python.framework/Versions/3.7/etc/openssl/certs

if [ ! -d "$DIRECTORY" ]; then
  sudo mkdir $DIRECTORY
fi


sudo ln -s /private/etc/ssl/certs/zscaler.pem $DIRECTORY/zscaler.pem