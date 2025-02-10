#!/bin/bash
# STEP 2: Generate a CSR for API Server Kubelet Client
openssl req -new -key apiserver-kubelet-client.key -subj "/CN=kube-apiserver-kubelet-client/O=system:masters" -out apiserver-kubelet-client.csr

if [ $? -eq 0 ]; then
  echo "API Server Kubelet Client CSR (apiserver-kubelet-client.csr) generated successfully."
else
  echo "Error generating API Server Kubelet Client CSR."
  exit 1
fi
