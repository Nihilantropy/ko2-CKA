#!/bin/bash
# STEP 1: Generate the kubelet private key (2048-bit RSA)
openssl genrsa -out kubelet.key 2048

if [ $? -eq 0 ]; then
  echo "kubelet private key (kubelet.key) generated successfully."
else
  echo "Error generating kubelet private key."
  exit 1
fi
