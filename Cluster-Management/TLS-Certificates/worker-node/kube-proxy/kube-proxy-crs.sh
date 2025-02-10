#!/bin/bash
# STEP 2: Generate a CSR for kube-proxy using its private key.
# The subject sets the common name and organization appropriately.
openssl req -new -key kube-proxy.key -subj "/CN=system:kube-proxy/O=system:node-proxier" -out kube-proxy.csr

if [ $? -eq 0 ]; then
  echo "kube-proxy CSR (kube-proxy.csr) generated successfully."
else
  echo "Error generating kube-proxy CSR."
  exit 1
fi
