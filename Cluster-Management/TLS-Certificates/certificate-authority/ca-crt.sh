#!/bin/bash
# STEP 3: Sign the CA certificate using the CA private key (self-signing)
openssl x509 -req -in ca.csr -signkey ca.key -out ca.cert

if [ $? -eq 0 ]; then
  echo "CA certificate (ca.cert) generated successfully."
else
  echo "Error generating CA certificate."
  exit 1
fi
