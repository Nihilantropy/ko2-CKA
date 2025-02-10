#!/bin/bash
# STEP 2: Generate a CSR for the kubelet client
openssl req -new -key kubelet-client.key -subj "/CN=system:kubelet-client/O=system:kubelet-client" -out kubelet-client.csr

if [ $? -eq 0 ]; then
  echo "Kubelet client CSR (kubelet-client.csr) generated successfully."
else
  echo "Error generating kubelet client CSR."
  exit 1
fi
