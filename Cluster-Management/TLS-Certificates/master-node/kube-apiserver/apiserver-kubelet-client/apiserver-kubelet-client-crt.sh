#!/bin/bash
# STEP 3: Sign the API Server Kubelet Client certificate using the CA certificate and CA key.
# This requires that the CA certificate (ca.cert) and CA key (ca.key) are in the same directory.

openssl x509 -req -in apiserver-kubelet-client.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out apiserver-kubelet-client.crt -days 365

if [ $? -eq 0 ]; then
  echo "API Server Kubelet Client certificate (apiserver-kubelet-client.crt) signed successfully."
else
  echo "Error generating API Server Kubelet Client certificate."
  exit 1
fi
