#!/bin/bash
# STEP 3: Sign the Controller Manager certificate using the CA certificate and CA key.
openssl x509 -req -in controller-manager.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out controller-manager.crt -days 365

if [ $? -eq 0 ]; then
  echo "Controller Manager certificate (controller-manager.crt) generated successfully."
else
  echo "Error generating Controller Manager certificate."
  exit 1
fi
