#!/bin/bash
# STEP 1: Generate the kube-scheduler private key (2048-bit RSA)
openssl genrsa -out kube-scheduler.key 2048

if [ $? -eq 0 ]; then
  echo "kube-scheduler private key (kube-scheduler.key) generated successfully."
else
  echo "Error generating kube-scheduler private key."
  exit 1
fi
