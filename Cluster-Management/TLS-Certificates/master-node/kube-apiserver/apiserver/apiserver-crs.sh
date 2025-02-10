#!/bin/bash
# STEP 2: Generate a CSR for the API Server using the private key and our custom OpenSSL config
openssl req -new -key apiserver.key -out apiserver.csr -config apiserver-openssl.cnf

if [ $? -eq 0 ]; then
  echo "API Server CSR (apiserver.csr) generated successfully."
else
  echo "Error generating API Server CSR."
  exit 1
fi
