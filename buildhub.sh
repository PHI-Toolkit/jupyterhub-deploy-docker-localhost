#!/bin/bash
if [[ "$(docker images -q jupyterhub:latest)" == "" ]]; then
  echo "JupyterHub image does not exist."
else
  docker rmi $(docker images -q jupyterhub:latest)
fi
docker-compose build
# Get jupyterhub host IP address
echo "Obtaining JupyterHub host ip address..."
FILE1='secrets/jupyterhub_host_ip'
if [ -f $FILE1 ]; then
    rm $FILE1
else
    touch $FILE1
fi
unset JUPYTERHUB_SERVICE_HOST_IP
docker-compose up -d
echo "Saving data to $FILE1..."
echo "JUPYTERHUB_SERVICE_HOST_IP='`docker inspect --format '{{ .NetworkSettings.Networks.jupyterhubnet.IPAddress }}' jupyterhub`'" >> $FILE1
docker-compose down
echo 'Set Jupyterhub Host IP:'
cat $FILE1
source $FILE1
rm $FILE1
echo "JUPYTERHUB_SERVICE_HOST_IP is now set to:"
echo $JUPYTERHUB_SERVICE_HOST_IP
echo "..."
sed -i -e "s/REPLACE_IP/$JUPYTERHUB_SERVICE_HOST_IP/g" .env
docker rmi $(docker images -q jupyterhub:latest)
docker rmi $(docker images -q postgres-hub:latest)
docker rmi $(docker images -q jupyterhub-user:latest)
echo "Rebuilding images..."
docker-compose build
make notebook_image
rm .env-e
echo "Build complete!"
