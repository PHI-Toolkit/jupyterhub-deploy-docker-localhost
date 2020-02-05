#!/bin/bash
# modified 2020-01-28
# author Herman Tolentino
if [[ ! -f .env ]]; then
    echo "Copying environment template..."
    cp .env-template .env
fi

source .env

# manage PostGreSQL data volume
if [[ $POSTGRES_DELETE_DB == 1 ]]; then
    echo "Creating PostgreSQL data volumes..."
    docker volume rm $DB_VOLUME_HOST
    docker volume create $DB_VOLUME_HOST
fi

# generate PostGreSQL password and proxy token
# update .env with values
if [[ ! -f secrets/pg_pass ]]; then
    echo "Generating PostGreSQL password..."
    ./pg_pass.sh
fi
if [[ ! -f secrets/proxy_token ]]; then
    echo "Generating JupyterHub proxy token..."
    ./proxy_token.sh
fi
if [[ ! -f userlist ]]; then
    echo "Copying userlist template..."
    cp userlist-template userlist
fi

# download miniconda to copy into Docker.jupyterhub
if [[ ! -f ./miniconda.sh ]]; then
    echo "Downloading miniconda..."
    MINICONDA_FILE=https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh
    while true;do
        wget -T 15 -c $MINICONDA_FILE -O ./miniconda.sh && break
    done
fi

./stophub.sh

if [[ "$(docker images -q jupyterhub:latest)" == "" ]]; then
  echo "JupyterHub image does not exist."
else
  echo "Deleting Docker images..."
  docker rmi $(docker images -a | grep jupyterhub | awk '{print $3}')
fi

# get images for base notebooks for Dockerfile.custom and Dockerfile.stacks
# uncommend other jupyter notebook containers below as needed
if [[ "$(docker images -q jupyter/minimal-notebook)" == "" ]]; then
    echo "Pulling jupyter stacks images..."
    #docker pull jupyter/datascience-notebook:$IMAGE_TAG
    #docker pull jupyter/scipy-notebook:$IMAGE_TAG
    #docker pull jupyter/r-notebook:$IMAGE_TAG
    docker pull jupyter/minimal-notebook:$IMAGE_TAG
    # legacy letsencrypt service
    docker pull quay.io/letsencrypt/letsencrypt:latest
fi

echo "Creating network and data volumes..."
make network volumes
docker volume create --name=nginx_vhostd
docker volume create --name=nginx_html

./create-network.sh

echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Creating SSL certificate..."
        ./create-certs.sh
        ;;
    use_ssl_le)
        # make letsencrypt server apps executable
        echo "Making LetsEncrypt apps executable..."
        chmod a+x server_apps/letsencrypt/app/cert_status
        chmod a+x server_apps/letsencrypt/app/entrypoint.sh
        chmod a+x server_apps/letsencrypt/app/force_renew
        chmod a+x server_apps/letsencrypt/app/functions.sh
        chmod a+x server_apps/letsencrypt/app/letsencrypt_service
        chmod a+x server_apps/letsencrypt/app/signal_le_service
        chmod a+x server_apps/letsencrypt/app/start.sh
        ;;
esac


echo "Building Docker images..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Shutting down JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml down
        ;;
    use_ssl_le)
        echo "Shutting down JupyterHub-LetsEncrypt..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml down
        ;;
esac
# Get jupyterhub host IP address
echo "Obtaining JupyterHub host ip address..."
FILE1='/tmp/jupyterhub_host_ip'
if [ -f $FILE1 ]; then
    rm $FILE1
else
    touch $FILE1
fi
unset JUPYTERHUB_SERVICE_HOST_IP
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Starting up JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose up -d
        ;;
    use_ssl_le)
        echo "Starting up JupyterHub-LetsEncrypt..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml up -d
        ;;
esac
docker inspect --format "{{ .NetworkSettings.Networks.jupyterhubnet.IPAddress }}" jupyterhub >> /tmp/jupyterhub_host_ip
bash ./stophub.sh
echo 'Set Jupyterhub Host IP:'
REPLACE_LINE="JUPYTERHUB_SERVICE_HOST_IP=`cat /tmp/jupyterhub_host_ip`"
echo "$REPLACE_LINE"
sed "s#.*JUPYTERHUB_SERVICE_HOST_IP.*#$REPLACE_LINE#g" .env > /tmp/envfile
cat /tmp/envfile > .env
rm /tmp/envfile
docker stop $(docker ps -a | grep jupyter- | awk '{print $1}')
docker rm $(docker ps -a | grep jupyter- | awk '{print $1}')
docker rmi $(docker images -q jupyterhub:latest)
docker rmi $(docker images -q postgres-hub:latest)
#docker rmi -f $(docker images -q jupyterhub-user:latest)
if [ ! -f 'singleuser/drive.jupyterlab-settings' ]; then
    echo "Copying Google drive JupyterLab settings template..."
    cp singleuser/drive.jupyterlab-settings-template singleuser/drive.jupyterlab-settings
fi
echo "Rebuilding JupyterHub and Single-user Docker images..."
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    use_ssl_ss)
        echo "Rebuilding JupyterHub..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose.yml build
        ;;
    use_ssl_le)
        echo "Rebuilding JupyterHub-LetsEncrypt..."
        COMPOSE_DOCKER_CLI_BUILD=$COMPOSE_DOCKER_CLI_BUILD docker-compose -f docker-compose-letsencrypt.yml build
        ;;
esac

echo "Building notebook image..."
make notebook_base
make notebook_body
make notebook_image
rc=$?
if [[ $rc -ne 0 ]]; then
  echo "Error was: $rc" >> errorlog.txt
else
  if [ -f .env-e ]; then
      rm .env-e
  fi
  echo "Build complete!"
  echo "Run starthub.sh from the command line..."
fi
