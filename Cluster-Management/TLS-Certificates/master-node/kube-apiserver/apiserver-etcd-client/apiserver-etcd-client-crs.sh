#!/bin/bash
# STEP 2: Generate a CSR for the API server etcd client using the private key
# The subject sets the Common Name to "kube-apiserver-etcd-client" to reflect its purpose.
openssl req -new -key apiserver-etcd.key -subj "/CN=apiserver-etcd-client" -out apiserver-etcd.csr

if [ $? -eq 0 ]; then
  echo "API server etcd client CSR (apiserver-etcd.csr) generated successfully."
else
  echo "Error generating API server etcd client CSR."
  exit 1
fi
