#!/bin/bash
# STEP 1: Generate CA private key (2048-bit RSA)
openssl genrsa -out ca.key 2048

if [ $? -eq 0 ]; then
	echo "CA private key (ca.key) generated successfully."
else
	echo "Error generating CA private key."
	exit 1
fi

