#!/bin/bash
# STEP 3: Sign the kube-admin certificate using the CA certificate and CA key
# Ensure ca.crt and ca.key are available in the same directory.
openssl x509 -req -in admin.csr \
    -CA ca.crt -CAkey ca.key -CAcreateserial \
    -out admin.cert -days 365

if [ $? -eq 0 ]; then
	echo "Signed certificate (admin.cert) generated successfully."
else
	echo "Error generating admin certificate."
	exit 1
fi