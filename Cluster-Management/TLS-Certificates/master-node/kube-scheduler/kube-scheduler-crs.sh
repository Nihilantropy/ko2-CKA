#!/bin/bash
# STEP 2: Generate a CSR for the kube-scheduler using its private key.
# The subject includes the common name and organization for the scheduler.
openssl req -new -key kube-scheduler.key -subj "/CN=system:kube-scheduler/O=system:kube-scheduler" -out kube-scheduler.csr

if [ $? -eq 0 ]; then
  echo "kube-scheduler CSR (kube-scheduler.csr) generated successfully."
else
  echo "Error generating kube-scheduler CSR."
  exit 1
fi
