#!/bin/bash
# STEP 1: Generate the etcd server private key (2048-bit RSA)
openssl genrsa -out etcdserver.key 2048

if [ $? -eq 0 ]; then
  echo "etcd server private key (etcdserver.key) generated successfully."
else
  echo "Error generating etcd server private key."
  exit 1
fi
