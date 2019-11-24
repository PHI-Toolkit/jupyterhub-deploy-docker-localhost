#!/bin/bash
echo "Starting up log tracking (Press ctrl-C to stop tracking, JupyterHub will continue running.)"
echo "..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        docker-compose logs --tail='all' -f -t
        ;;
    use_ssl_le)
        docker-compose -f docker-compose-letsencrypt.yml logs --tail='all' -f -t
        ;;
esac
