#!/bin/bash
# STEP 3: Sign the kubelet client certificate using the CA certificate and CA key.
# This requires that the CA certificate (ca.cert) and CA key (ca.key) are in the same directory.

openssl x509 -req -in kubelet-client.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out kubelet-client.crt -days 365

if [ $? -eq 0 ]; then
  echo "Kubelet client certificate (kubelet-client.crt) signed successfully."
else
  echo "Error generating kubelet client certificate."
  exit 1
fi
