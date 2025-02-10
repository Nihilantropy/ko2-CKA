#!/bin/bash
# STEP 1: Generate the private key for API Server Kubelet Client
openssl genrsa -out apiserver-kubelet-client.key 2048

if [ $? -eq 0 ]; then
  echo "API Server Kubelet Client private key (apiserver-kubelet-client.key) generated successfully."
else
  echo "Error generating API Server Kubelet Client private key."
  exit 1
fi
