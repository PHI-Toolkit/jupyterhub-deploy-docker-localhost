#!/bin/bash
FILE='secrets/jupyterhub_host_ip'
if [ -f $FILE ]; then
    rm $FILE
else
    touch $FILE
fi
unset JUPYTERHUB_SERVICE_HOST_IP
docker-compose up -d
echo "JUPYTERHUB_SERVICE_HOST_IP='`docker inspect --format '{{ .NetworkSettings.Networks.jupyterhubnet.IPAddress }}' jupyterhub`'" >> $FILE
docker-compose down
echo 'Set Jupyterhub Host IP:'
cat $FILE
source $FILE
