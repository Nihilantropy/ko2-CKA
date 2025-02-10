#!/bin/bash
# STEP 3: Sign the kube-scheduler certificate using the CA certificate and CA key.
openssl x509 -req -in kube-scheduler.csr \
    -CA ca.cert -CAkey ca.key -CAcreateserial \
    -out kube-scheduler.crt -days 365

if [ $? -eq 0 ]; then
  echo "kube-scheduler certificate (kube-scheduler.crt) generated successfully."
else
  echo "Error generating kube-scheduler certificate."
  exit 1
fi
