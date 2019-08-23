#!/bin/bash
# revised 2019-08-18
# maintainer: herman.tolentino@gmail.com
# --------------------------------------
# purpose: obtain JupyterHub Service Host
#          IP Address and update the
#          JUPYTERHUB_SERVICE_HOST_IP
#          value in the .env file
# --------------------------------------
FILE='secrets/jupyterhub_host_ip'
if [ -f $FILE ]; then
    rm $FILE
else
    touch $FILE
fi
unset JUPYTERHUB_SERVICE_HOST_IP
docker-compose up -d
echo "JUPYTERHUB_SERVICE_HOST_IP=`docker inspect --format '{{ .NetworkSettings.Networks.jupyterhubnet.IPAddress }}' jupyterhub`" >> $FILE
docker-compose down
echo 'Set Jupyterhub Host IP:'
REPLACE_LINE=`cat $FILE`
echo $REPLACE_LINE
sed "s#.*JUPYTERHUB_SERVICE_HOST_IP.*#$REPLACE_LINE#g" .env > secrets/file
cat secrets/file > .env
rm secrets/file
./starthub.sh
