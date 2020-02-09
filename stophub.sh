#!/bin/bash
# modified 2020-01-01
# author Herman Tolentino
source .env
if [[ "$(docker ps -a | grep jupyter- | awk '{print $1}')" != "" ]]; then
    docker stop $(docker ps -a | grep jupyter- | awk '{print $1}')
    docker rm $(docker ps -a | grep jupyter- | awk '{print $1}')
fi

case $JUPYTERHUB_SSL in
    no_ssl)
        echo "Shutting down JupyterHub..."
        docker-compose -f docker-compose.yml down
        ;;
    use_ssl_ss)
        echo "Shutting down JupyterHub..."
        docker-compose -f docker-compose.yml down
        ;;
    use_ssl_le)
        echo "Shutting down JupyterHub-LetsEncrypt..."
        docker-compose -f docker-compose-letsencrypt.yml down
        ;;
esac
