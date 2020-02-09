#!/bin/bash
# revised 2020-01-01
# maintainer: herman.tolentino@gmail.com
# --------------------------------------
# purpose: obtain JupyterHub Service Host
#          IP Address and update the
#          JUPYTERHUB_SERVICE_HOST_IP
#          value in the .env file
# --------------------------------------
FILE='/tmp/jupyterhub_host_ip'
if [ -f $FILE ]; then
    rm $FILE
else
    touch $FILE
fi
unset JUPYTERHUB_SERVICE_HOST_IP
echo "JUPYTERHUB_SSL = $JUPYTERHUB_SSL"
case $JUPYTERHUB_SSL in
    no_ssl)
        echo "Starting up JupyterHub..."
        docker-compose up -d
        ;;
    use_ssl_ss)
        echo "Starting up JupyterHub..."
        docker-compose up -d
        ;;
    use_ssl_le)
        echo "Starting up JupyterHub-LetsEncrypt..."
        docker-compose -f docker-compose-letsencrypt.yml up -d
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
echo "Starting up JupyterHub"
bash ./starthub.sh
