#!/bin/bash
# STEP 1: Generate private key for kube-admin
openssl genrsa -out admin.key 2048

if [ $? -eq 0 ]; then
	echo "Private key (admin.key) generated successfully."
else
  echo "Error generating admin private key."
  exit 1
fi