#!/bin/bash
# STEP 3: Sign the kubelet certificate using the CA certificate and CA key.
# This requires that the CA certificate (ca.cert) and CA key (ca.key) are in the same directory.

openssl x509 -req -in kubelet.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out kubelet.crt -days 365

if [ $? -eq 0 ]; then
  echo "kubelet certificate (kubelet.crt) signed successfully."
else
  echo "Error generating kubelet certificate."
  exit 1
fi
