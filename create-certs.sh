#!/bin/bash
# Use self-signed certificate only for testing'
if [[ ! -d secrets ]]; then
    echo "Creating 'secrets' directory..."
    mkdir -p secrets
fi
if [[ $JUPYTERHUB_SSL == 'use_ssl_ss' ]]; then
    echo "Creating self-signed SSL certificate..."
    export SSL_COUNTRY='US'
    export SSL_STATE='GA'
    export SSL_LOC='Atlanta'
    export SSL_ORG='geeks'
    export SSL_OU='geeks'
    export SSL_CN='geeks.io'
    echo "Generating self-signed certificates..."
    openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
      -keyout secrets/jupyterhub.key -out secrets/jupyterhub.pem \
      -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOC/O=$SSL_ORG/OU=$SSL_OU/CN=$SSL_CN"
    cp secrets/jupyterhub.key secrets/default.key
    cp secrets/jupyterhub.pem secrets/default.pem
else
    echo "LetsEncrypt SSL certificate will be created during LetsEncrypt container launch..."
fi
