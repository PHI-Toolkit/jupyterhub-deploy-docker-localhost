#!/bin/bash
# Use self-signed certificate only for testing
mkdir secrets
openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
  -subj "/C=US/ST=GA/L=Atlanta/O=CDC/CN=geeks.io" \
  -keyout secrets/jupyterhub.key -out secrets/jupyterhub.pem

cp secrets/jupyterhub.key secrets/default.key
cp secrets/jupyterhub.pem secrets/default.pem
