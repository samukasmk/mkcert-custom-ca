#!/bin/bash

# define paths
CA_FOLDER="./certs/ca"
CA_ROOT_FILE="$CA_FOLDER/rootCA.pem"
CA_KEY_FILE="$CA_FOLDER/rootCA-key.pem"

CERTS_FOLDER="./certs/localhost"
CERT_FILE="$CERTS_FOLDER/localhost.crt"
KEY_FILE="$CERTS_FOLDER/localhost.key"

# create folders
mkdir -p "$CA_FOLDER"
mkdir -p "$CERTS_FOLDER"

# generate CA root files in local folder
if [[ ! -f "$CA_ROOT_FILE" || ! -f "$CA_KEY_FILE" ]]; then
  openssl req -x509 -newkey rsa:4096 -nodes \
    -keyout "$CA_KEY_FILE" \
    -out "$CA_ROOT_FILE" \
    -days 9650 \
    -subj "/C=BR/ST=SP/L=SaoPaulo/O=.SMKTech/OU=TI/CN=SMk Technology CA"
fi

# copy ca certs to CAROOT folder
CAROOT_SYSTEM=$(mkcert -CAROOT)
rm -f "$CAROOT_SYSTEM/*.pem"
sudo cp "$CA_ROOT_FILE" "$CAROOT_SYSTEM/"
sudo cp "$CA_KEY_FILE" "$CAROOT_SYSTEM/"

# install certs in browsers
CAROOT=$CAROOT_SYSTEM
mkcert -install

# generate CERTS files in local folder
if [[ ! -f "$CERT_FILE" || ! -f "$KEY_FILE" ]]; then
  mkcert \
    -cert-file "$CERT_FILE" -key-file "$KEY_FILE" \
    '127.0.0.1' '1::' 'localhost' \
    '*.localhost' '*.local' '*.docker.internal' \
    '127-0-0-1.nip.io' '127.0.0.1.nip.io' \
    '*.127-0-0-1.nip.io' '*.127.0.0.1.nip.io' \
    '*.apps.127-0-0-1.nip.io' '*.apps.127.0.0.1.nip.io' \
    '127-0-0-1.sslip.io' '127.0.0.1.sslip.io' \
    '*.127-0-0-1.sslip.io' '*.127.0.0.1.sslip.io' \
    '*.apps.127-0-0-1.sslip.io' '*.apps.127.0.0.1.sslip.io'
fi
