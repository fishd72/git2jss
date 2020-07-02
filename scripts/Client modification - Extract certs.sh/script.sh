#!/bin/bash

/usr/bin/security find-certificate -a -p /System/Library/Keychains/SystemRootCertificates.keychain > /etc/ssl/certs/ca-certs.pem
/usr/bin/security find-certificate -a -p /Library/Keychains/System.keychain -e "zscaler.com" >> /etc/ssl/certs/ca-certs.pem
/usr/bin/security find-certificate -a -p -c "Zscaler" /Library/Keychains/System.keychain > /etc/ssl/certs/zscaler.pem