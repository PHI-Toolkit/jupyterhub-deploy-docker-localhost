#!/bin/bash
# letsencrypt-certs.sh: renew LetsEncrypt certificates
# updated 8/20/2019
# maintainer: herman.tolentino@gmail.com
#
# change the default values of the exported variables as needed in .env
#
echo 'Running LetsEncrypt routine...'
source .env
if [[ ! -d secrets ]]; then
    echo "Creating 'secrets' directory..."
    mkdir -p secrets
fi
echo 'Testing exit conditions...'
if [ "$JUPYTERHUB_SSL" == "use_ssl_le" ]; then
    echo 'JUPYTERHUB_SSL in .env is set to "use_ssl_le".'
else
    echo "JUPYTERHUB_SSL: $JUPYTERHUB_SSL"
    echo 'JUPYTERHUB_SSL in .env is not set to "use_ssl_le".'
    exit
fi
if [[ "$JH_FQDN" == "" ]]; then
    echo '$JH_FQDN environment variable not set.'.
    exit
fi
if [[ "$JH_EMAIL" == "" ]]; then
    echo '$JH_EMAIL environment variable not set.'.
    exit
fi
echo 'Testing exit conditions...done.'
echo 'Using the following LetsEncrypt parameters:'
echo "JH_FQDN = $JH_FQDN"
echo "JH_EMAIL = $JH_EMAIL"
echo "CERT_SERVER = $CERT_SERVER"
if [[ -f "secrets/fullchain.pem" ]]; then
    echo "LetsEncrypt files found. Testing file modification time..."
    if test `find "./secrets/fullchain.pem" -mtime +80`; then
    #if [[ test `find "./secrets/live/$JH_FQDN" -mindepth 1 -mtime +80`]]; then
        echo "LetsEncrypt files old enough (>80 days)to renew."
        rm ./secrets/*.pem
        rm ./secrets/*.key
    else
        echo "LetsEncrypt files are relatively new. Exiting LetsEncrypt routine..."
        exit
    fi
fi

export JH_SECRETS="`pwd`/secrets"
export JH_COMMAND="letsencrypt.sh --domain $JH_FQDN --email $JH_EMAIL --volume $JH_SECRETS"
export CERT_SERVER=$CERT_SERVER # set this to "--staging" in .env if testing script settings
echo $JH_FQDN $JH_EMAIL $JH_SECRETS $CERT_SERVER
echo "Generating LetsEncrypt certificates..."
docker run --rm -it \
  -p 80:80 \
  -v $JH_SECRETS:/etc/letsencrypt \
  quay.io/letsencrypt/letsencrypt:latest \
  certonly \
  --non-interactive \
  --keep-until-expiring \
  --standalone \
  --preferred-challenges http \
  --agree-tos \
  --force-renewal \
  --domain "$JH_FQDN" \
  --email "$JH_EMAIL" \
  $CERT_SERVER

  # Set permissions so nobody can read the cert and key.
  # Also symlink the certs into the root of the /etc/letsencrypt
  # directory so that the FQDN doesn't have to be known later.
docker run --rm -it \
    -v $JH_SECRETS:/etc/letsencrypt \
    --entrypoint=/bin/bash \
    quay.io/letsencrypt/letsencrypt:latest \
    -c "find /etc/letsencrypt/* -maxdepth 1 -type l -delete && \
      ln -s /etc/letsencrypt/live/$JH_FQDN/* /etc/letsencrypt/ && \
      find /etc/letsencrypt -type d -exec chmod 755 {} +"
rm secrets/*.pem
rm secrets/*.key
rm secrets/README
cp secrets/live/$JH_FQDN/fullchain.pem secrets/fullchain.pem
cp secrets/live/$JH_FQDN/privkey.pem secrets/privkey.pem
chown -R ${INSTALL_USER} secrets/
chmod a+r secrets/privkey.pem
cp secrets/privkey.pem secrets/$JH_FQDN.key
cp secrets/fullchain.pem secrets/$JH_FQDN.pem
cp secrets/privkey.pem secrets/jupyterhub.key
cp secrets/fullchain.pem secrets/jupyterhub.pem
cp secrets/jupyterhub.key secrets/default.key
cp secrets/jupyterhub.pem secrets/default.pem

echo "LetsEncrypt routine completed..."
