#!/bin/bash
# STEP 2: Generate a certificate signing request (CSR) for kube-admin
# O=system:masters include the admin user in the master group
openssl req -new -key admin.key -subj "/CN=kube-admin/O=system:masters" -out admin.csr

if [ $? -eq 0 ]; then
	echo "Certificate signing request (admin.csr) generated successfully."
else
	echo "Error generating admin CSR."
	exit 1
fi