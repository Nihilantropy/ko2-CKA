#!/bin/bash
# STEP 2: Generate a CSR for the Controller Manager using the private key
# The subject includes the common name and organization for the Controller Manager.
openssl req -new -key controller-manager.key -subj "/CN=system:kube-controller-manager/O=system:kube-controller-manager" -out controller-manager.csr

if [ $? -eq 0 ]; then
  echo "Controller Manager CSR (controller-manager.csr) generated successfully."
else
  echo "Error generating Controller Manager CSR."
  exit 1
fi
