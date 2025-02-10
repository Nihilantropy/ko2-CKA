#!/bin/bash
# STEP 1: Generate the API Server private key (2048-bit RSA)
openssl genrsa -out apiserver.key 2048

if [ $? -eq 0 ]; then
  echo "API Server private key (apiserver.key) generated successfully."
else
  echo "Error generating API Server private key."
  exit 1
fi
