#!/bin/bash
# STEP 2: Generate a CSR for the CA using the private key
openssl req -new -key ca.key -subj "/CN=KUBERNETE-CA" -out ca.csr

if [ $? -eq 0 ]; then
	echo "CA certificate signing request (ca.csr) generated successfully."
else
	echo "Error generating CA CSR."
	exit 1
fi
