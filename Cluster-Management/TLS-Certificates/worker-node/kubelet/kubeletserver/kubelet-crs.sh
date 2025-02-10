#!/bin/bash
# STEP 2: Generate a CSR for kubelet using its private key.
# Replace <NODE_NAME> with the actual hostname of the node
NODE_NAME=$(hostname)

openssl req -new -key kubelet.key -subj "/CN=system:node:${NODE_NAME}/O=system:nodes" -out kubelet.csr

if [ $? -eq 0 ]; then
  echo "kubelet CSR (kubelet.csr) generated successfully for node ${NODE_NAME}."
else
  echo "Error generating kubelet CSR."
  exit 1
fi
