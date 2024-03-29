#!/bin/bash
# Use self-signed certificate only for testing'

# 2021-09-27

source .env
if [[ ! -d secrets ]]; then
    echo "Creating 'secrets' directory..."
    mkdir -p secrets
fi
echo "JUPYTERHUB_SSL=$JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Creating self-signed SSL certificate..."
        export SSL_COUNTRY='US'
        export SSL_STATE='GA'
        export SSL_LOC='Atlanta'
        export SSL_ORG='geeks'
        export SSL_OU='geeks'
        export SSL_CN='epispider.io'
        echo "Generating self-signed certificates..."
        openssl req -x509 -nodes -days 365 -newkey rsa:1024 \
          -keyout secrets/jupyterhub.key -out secrets/jupyterhub.pem \
          -subj "/C=$SSL_COUNTRY/ST=$SSL_STATE/L=$SSL_LOC/O=$SSL_ORG/OU=$SSL_OU/CN=$SSL_CN"
        cp secrets/jupyterhub.key secrets/default.key
        cp secrets/jupyterhub.pem secrets/default.pem
        ;;
    use_ssl_le)
        echo "LetsEncrypt SSL certificate will be created during LetsEncrypt container launch..."
        echo "Run init.sh at the command line after buildhub.sh. You will be prompted to provide an admin password to execute init.sh."
        ;;
esac
