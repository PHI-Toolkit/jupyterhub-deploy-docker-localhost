#!/bin/bash
# 2018-05-29

if [[ ! -f .env ]]; then
  cp .env-template .env
fi
# generate PostGreSQL password and proxy token
# update .env with values
./pg_pass.sh
./proxy_token.sh

if [[ ! -f userlist ]]; then
  cp userlist-template userlist
fi

source .env

./stophub.sh

if [[ "$(docker images -q jupyterhub:latest)" == "" ]]; then
  echo "JupyterHub image does not exist."
else
  echo "Deleting Docker images..."
  docker rmi $(docker images -a | grep jupyterhub | awk '{print $3}')
fi

# get images for base notebooks for Dockerfile.custom and Dockerfile.stacks
if [[ "$(docker images -q jupyter/minimal-notebook)" == "" ]]; then
  docker pull jupyter/datascience-notebook:$IMAGE_TAG
  docker pull jupyter/scipy-notebook:$IMAGE_TAG
  docker pull jupyter/r-notebook:$IMAGE_TAG
  docker pull jupyter/minimal-notebook:$IMAGE_TAG
  docker pull quay.io/letsencrypt/letsencrypt:latest
fi

echo "Creating network and volumes..."
make network volumes

echo "Creating SSL certificate..."
if [ "$JUPYTERHUB_SSL" == "use_ssl_ss" ]; then
  echo "Creating self-signed SSL certificate..."
  ./create-certs.sh
else
  if [ "$JUPYTERHUB_SSL" == "no_ssl" ]; then
    echo "no_ssl is deprecated. "
    echo "Please select SSL option: use_ssl_ss or use_ssl_le in the .env file. Exiting..."
    exit
  else
    echo "Creating LetsEncrypt SSL certificate..."
    ./letsencrypt-certs.sh
  fi
fi
echo "Building Docker images..."
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
docker stop $(docker ps -a | grep jupyter- | awk '{print $1}')
docker rm $(docker ps -a | grep jupyter- | awk '{print $1}')
docker rmi $(docker images -q jupyterhub:latest)
docker rmi $(docker images -q postgres-hub:latest)
#docker rmi -f $(docker images -q jupyterhub-user:latest)
if [ ! -f 'singleuser/drive.jupyterlab-settings' ]; then
    cp singleuser/drive.jupyterlab-settings-template singleuser/drive.jupyterlab-settings
fi
if [ ! -f userlist ]; then
    cp userlist-template userlist
fi
echo "Rebuilding Docker images..."
docker-compose build

echo "Building notebook image..."
make notebook_image
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "Error was: $rc" >> errorlog.txt
else
  if [ -f .env-e ]; then
      rm .env-e
  fi
  echo "Build complete!"
fi
