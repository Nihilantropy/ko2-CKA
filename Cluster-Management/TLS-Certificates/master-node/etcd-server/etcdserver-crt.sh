#!/bin/bash
# STEP 3: Sign the etcd server certificate using the CA certificate and CA key.
openssl x509 -req -in etcdserver.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out etcdserver.crt -days 365

if [ $? -eq 0 ]; then
  echo "etcd server certificate (etcdserver.crt) generated successfully."
else
  echo "Error generating etcd server certificate."
  exit 1
fi
