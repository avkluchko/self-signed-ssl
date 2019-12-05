#!/usr/bin/env bash

read -e -p "Domain name: " -i "mysite.localhost" DOMAIN

if [ -z "$DOMAIN" ]
then
  echo "Please supply a domain name to create a certificate for";
  echo "e.g. mysite.localhost"
  exit;
else
  echo $DOMAIN
fi

read -e -p "Output file name (/path/cert): " -i "$DOMAIN" OUTPUT_FILE

read -e -p "Number of days certificate: " -i 365 NUM_OF_DAYS

COMMON_NAME=${2:-$DOMAIN}
read -e -p "Common name: " -i "$COMMON_NAME" COMMON_NAME

SUBJECT="/C=CA/ST=None/L=NB/O=None/CN=$COMMON_NAME"
read -e -p "Certificate subject: " -i "$SUBJECT" SUBJECT

PRIVATEKEY="$DOMAIN.key"
read -e -p "Private key file (create new if doesnt exist): " -i "$PRIVATEKEY" PRIVATEKEY
# Create a new private key if one doesnt exist, or use the xeisting one if it does
if [ -f $PRIVATEKEY ]; then
  KEY_OPT="-key"
else
  KEY_OPT="-keyout"
fi 

CA_PUBLIC="rootCA.pem"
read -e -p "CA public file: " -i "$CA_PUBLIC" CA_PUBLIC

CA_PRIVATE="rootCA.key"
read -e -p "CA private key file: " -i "$CA_PRIVATE" CA_PRIVATE

openssl req -new -newkey rsa:4096 -sha256 -nodes \
    $KEY_OPT $PRIVATEKEY -subj "$SUBJECT" \
    -out $DOMAIN.csr

cat v3.ext | sed s/%%DOMAIN%%/$COMMON_NAME/g > /tmp/__v3.ext

openssl x509 -req -in $DOMAIN.csr -days $NUM_OF_DAYS -sha256 \
    -CA $CA_PUBLIC -CAkey $CA_PRIVATE -CAcreateserial \
    -out $DOMAIN.crt -extfile /tmp/__v3.ext 

echo 
echo "###########################################################################"
echo Done! 
echo "###########################################################################"
echo "To use these files on your server, simply copy both $DOMAIN.crt and"
echo "device.key to your webserver, and use like so (if Apache, for example)"
echo 
echo "    SSLCertificateFile    /path_to_your_files/$DOMAIN.crt"
echo "    SSLCertificateKeyFile /path_to_your_files/$DOMAIN.key"