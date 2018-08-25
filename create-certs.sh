#!/bin/bash
# Use self-signed certificate only for testing
if [[ ! -d secrets ]]; then
    echo "Creating 'secrets' directory..."
    mkdir -p secrets
fi
if [[ ! -f secrets/jupyterhub.pem ]]; then
    echo "Generating self-signed certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
      -subj "/C=US/ST=GA/L=Atlanta/O=CDC/CN=geeks.io" \
      -keyout secrets/jupyterhub.key -out secrets/jupyterhub.pem

    cp secrets/jupyterhub.key secrets/default.key
    cp secrets/jupyterhub.pem secrets/default.pem
fi
