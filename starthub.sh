#!/bin/bash
# modified 2020-01-01
# author: Herman Tolentino
source .env
echo "Starting up JupyterHub"
echo "..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Starting up JupyterHub..."
        docker-compose -f docker-compose.yml up -d
        echo "JupyterHub started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub server."
        docker-compose -f docker-compose.yml logs -f -t --tail='all'
        ;;
    use_ssl_le)
        echo "Starting up JupyterHub-LetsEncrypt..."
        if [[ ! -f  secrets/jupyterhub.pem ]]; then
            echo "Copying JupyterHub SSL certificate - please provide sudo password..."
            docker exec jupyterhub bash -c 'echo JH_FQDN: $JH_FQDN'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/fullchain.pem /srv/jupyterhub/secrets/jupyterhub.pem'
            docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/key.pem /srv/jupyterhub/secrets/jupyterhub.key'
        fi
        docker-compose -f docker-compose-letsencrypt.yml up -d
        echo "JupyterHub-LetsEncrypt started. Press ctrl-C to stop tracking, JupyterHub will continue running."
        echo "Run stophub.sh on the command line to stop the JupyterHub-LetsEncrypt servers."
        docker-compose -f docker-compose-letsencrypt.yml logs -f -t --tail='all'
        ;;
esac
bash logs.sh
