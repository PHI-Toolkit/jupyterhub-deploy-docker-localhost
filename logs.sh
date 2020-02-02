#!/bin/bash
source .env
echo "Starting up log tracking (Press ctrl-C to stop tracking, you may have to do this twice. JupyterHub will continue running in the background.)"
echo "..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose logs --tail='all' -f -t
        ;;
    use_ssl_le)
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml logs --tail='all' -f -t
        ;;
esac
