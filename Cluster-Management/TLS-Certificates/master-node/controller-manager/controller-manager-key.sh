#!/bin/bash
# STEP 1: Generate the Controller Manager private key (2048-bit RSA)
openssl genrsa -out controller-manager.key 2048

if [ $? -eq 0 ]; then
  echo "Controller Manager private key (controller-manager.key) generated successfully."
else
  echo "Error generating Controller Manager private key."
  exit 1
fi
