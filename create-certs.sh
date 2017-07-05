#!/bin/bash
# Use self-signed certificate only for testing
mkdir secrets
openssl req -new -newkey rsa:4096 -days 365 -nodes -x509 \
    -subj "/C=US/ST=GA/L=Atlanta/O=CDC/CN=geeks.moph" \
    -keyout secrets/jupyterhub.key  -out secrets/jupyterhub.crt
