#!/bin/bash
# STEP 3: Sign the kube-proxy certificate using the CA certificate and CA key.
openssl x509 -req -in kube-proxy.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out kube-proxy.crt -days 365

if [ $? -eq 0 ]; then
  echo "kube-proxy certificate (kube-proxy.crt) generated successfully."
else
  echo "Error generating kube-proxy certificate."
  exit 1
fi
