#!/bin/bash
# STEP 3: Sign the API Server certificate using the CA certificate and CA key.
# -extfile and -extensions ensure that the SANs from our OpenSSL config are included.
openssl x509 -req -in apiserver.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out apiserver.crt -days 365 \
    -extensions req_ext -extfile apiserver-openssl.cnf

if [ $? -eq 0 ]; then
  echo "API Server certificate (apiserver.crt) generated successfully."
else
  echo "Error generating API Server certificate."
  exit 1
fi
