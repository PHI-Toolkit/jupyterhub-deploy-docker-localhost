#!/bin/bash
# modified 2020-02-05
# author: Herman Tolentino
source .env
echo "Starting up JupyterHub"
echo "..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Starting up JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml up -d
        echo "JupyterHub started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub server."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml logs -f -t --tail='all'
        ;;
    use_ssl_le)
        echo "Starting up JupyterHub-LetsEncrypt..."
        FULLCHAIN_NAME=secrets/$JH_FQDN/fullchain.pem
        FULLCHAIN_SIZE=$(stat -c%s "$FULLCHAIN_NAME")
        KEY_NAME=secrets/$JH_FQDN/key.pem
        KEY_SIZE=$(stat -c%s "$KEY_NAME")
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml up -d
        if [[ $FULLCHAIN_SIZE != $KEY_SIZE ]]; then
            echo "Copying JupyterHub SSL certificate..."
            docker exec jupyterhub bash -c 'echo JH_FQDN: $JH_FQDN'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/fullchain.pem /srv/jupyterhub/secrets/jupyterhub.pem'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/key.pem /srv/jupyterhub/secrets/jupyterhub.key'
        fi
        echo "JupyterHub-LetsEncrypt started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub-LetsEncrypt servers."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml logs -f -t --tail='all'
        ;;
esac
