#!/usr/bin/bash

# domain name
DNAME="xxx.com"
# acme.sh path
ACME_PATH="/root/.acme.sh"
# certs install dir path
#       UGOS PRO                      FNOS
# PATH  /ugreen/.config/ssl/certs     /usr/trim/var/trim_connect/ssls
CERTS_PATH="/usr/trim/var/trim_connect/ssls/$DNAME"
# file name
#       UGOS PRO        FNOS
# KEY   privkey.pem     $DNAME.key
# CERT  cert.pem        $DNAME.crt
KEY_FILE="$CERTS_PATH/$DNAME.key"
CERT_FILE="$CERTS_PATH/$DNAME.key"

rm -rf $CERTS_PATH
mkdir $CERTS_PATH

bash $ACME_PATH/acme.sh --install-cert -d $DNAME \
--key-file       $KEY_FILE \
--fullchain-file $CERT_FILE

/sbin/reboot
