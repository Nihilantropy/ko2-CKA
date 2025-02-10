#!/bin/bash
# STEP 1: Generate the API server etcd client private key (2048-bit RSA)
openssl genrsa -out apiserver-etcd.key 2048

if [ $? -eq 0 ]; then
  echo "API server etcd client private key (apiserver-etcd.key) generated successfully."
else
  echo "Error generating API server etcd client private key."
  exit 1
fi
