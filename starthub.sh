#!/bin/bash
# modified 2020-02-05
# author: Herman Tolentino
source .env
echo "Starting up JupyterHub"
echo "..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    no_ssl)
        echo "Starting up JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml up -d
        echo "JupyterHub started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub server."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml logs -f -t --tail='all'
        ;;
    use_ssl_ss)
        echo "Starting up JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml up -d
        echo "JupyterHub started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub server."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml logs -f -t --tail='all'
        ;;
    use_ssl_le)
        echo "Starting up JupyterHub-LetsEncrypt..."
        FULLCHAINPEM_NAME=secrets/$JH_FQDN/fullchain.pem
        FULLCHAINPEM_SIZE=$(stat -c%s "$FULLCHAINPEM_NAME")
        JUPYTERPEM_NAME=secrets/$JH_FQDN/key.pem
        JUPYTERPEM_SIZE=$(stat -c%s "$JUPYTERPEM_NAME")
        DEFAULTCRT_NAME=secrets/default.crt
        DEFAULTCRT_SIZE=$(stat -c%s "$DEFAULTCRT_NAME")
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml up -d
        sleep 10
        if [[ $FULLCHAINPEM_SIZE != $JUPYTERPEM_SIZE ]]; then
            echo "Copying JupyterHub SSL certificate..."
            docker exec jupyterhub bash -c 'echo JH_FQDN: $JH_FQDN'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/fullchain.pem /srv/jupyterhub/secrets/jupyterhub.pem'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/key.pem /srv/jupyterhub/secrets/jupyterhub.key'
        fi
        if [[ $DEFAULTCRT_SIZE != $JUPYTERPEM_SIZE ]]; then
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/fullchain.pem /srv/jupyterhub/secrets/default.crt'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/jupyterhub.key /srv/jupyterhub/secrets/default.key'
        fi
        echo "JupyterHub-LetsEncrypt started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub-LetsEncrypt servers."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml logs -f -t --tail='all'
        ;;

esac
