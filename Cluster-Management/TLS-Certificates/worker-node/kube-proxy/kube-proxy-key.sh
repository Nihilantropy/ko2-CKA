#!/bin/bash
# STEP 1: Generate the kube-proxy private key (2048-bit RSA)
openssl genrsa -out kube-proxy.key 2048

if [ $? -eq 0 ]; then
  echo "kube-proxy private key (kube-proxy.key) generated successfully."
else
  echo "Error generating kube-proxy private key."
  exit 1
fi
