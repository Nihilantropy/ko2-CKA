#!/bin/bash
# STEP 2: Generate a Certificate Signing Request (CSR) for the etcd server using its private key.
openssl req -new -key etcdserver.key -subj "/CN=etcd-server" -out etcdserver.csr

if [ $? -eq 0 ]; then
  echo "etcd server CSR (etcdserver.csr) generated successfully."
else
  echo "Error generating etcd server CSR."
  exit 1
fi
