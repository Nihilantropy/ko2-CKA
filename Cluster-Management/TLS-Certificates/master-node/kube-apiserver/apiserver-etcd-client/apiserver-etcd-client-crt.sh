#!/bin/bash
# STEP 3: Sign the API server etcd client certificate using the CA certificate and CA key.
# The -CAcreateserial option creates a serial file if one doesn’t exist.
openssl x509 -req -in apiserver-etcd.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out apiserver-etcd.crt -days 365

if [ $? -eq 0 ]; then
  echo "API server etcd client certificate (apiserver-etcd.crt) generated successfully."
else
  echo "Error generating API server etcd client certificate."
  exit 1
fi
