#!/bin/bash
if [[ "$(docker images -q jupyterhub:latest)" == "" ]]; then
  echo "JupyterHub image does not exist."
  docker-compose build
fi
echo "Obtaining JupyterHub host ip address..."
bash get_service_host_ip.sh
docker rmi $(docker images -q jupyterhub:latest)
docker rmi $(docker images -q postgres-hub:latest)
echo "Rebuilding images..."
docker-compose build
echo "Build complete!"

