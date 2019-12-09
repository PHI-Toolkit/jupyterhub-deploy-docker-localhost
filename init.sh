#!/bin/bash
source .env
#sudo cp secrets/$JH_FQDN/fullchain.pem secrets/jupyterhub.pem
#sudo cp secrets/$JH_FQDN/key.pem secrets/jupyterhub.key
docker exec jupyterhub bash -c 'echo JH_FQDN: $JH_FQDN'
docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/fullchain.pem /srv/jupyterhub/secrets/jupyterhub.pem'
docker exec jupyterhub bash -c 'cp /srv/jupyterhub/secrets/$JH_FQDN/key.pem /srv/jupyterhub/secrets/jupyterhub.key'
