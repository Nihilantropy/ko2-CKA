#!/bin/bash
# STEP 1: Generate the kubelet client private key (2048-bit RSA)
openssl genrsa -out kubelet-client.key 2048

if [ $? -eq 0 ]; then
  echo "Kubelet client private key (kubelet-client.key) generated successfully."
else
  echo "Error generating kubelet client private key."
  exit 1
fi
