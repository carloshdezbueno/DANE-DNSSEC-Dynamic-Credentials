#!/bin/bash

export DOMAIN="hogehoge.hoge"
export RECORD_NAME="test"

sudo openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
-out /cacert/MyCertificate.crt -keyout /cacert/MyKey.key \
-subj "/C=ES/ST=MA/L=MA/O=UC3M/OU=IT/CN=$DOMAIN/emailAddress=admin@$DOMAIN"

sha256_checksum=$(sha256sum /cacert/MyCertificate.crt | awk '{print $1}')

# Set environment variables
export IP_ADDRESS=$(curl -s ifconfig.me)
export TLSA_DATA="3 1 1 $sha256_checksum"
export URL="http://127.0.0.1:5000/add_record"

# Run curl command
curl -X POST \
  -H "Content-Type: application/json" \
  -d '{
    "domain": "'"$DOMAIN"'",
    "record_name": "'"$RECORD_NAME"'",
    "ip_address": "'"$IP_ADDRESS"'",
    "tlsa_data": "'"$TLSA_DATA"'"
  }' \
  "$URL"
