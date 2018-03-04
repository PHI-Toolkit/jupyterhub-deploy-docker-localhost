#!/bin/bash
# change the values of the exported variables as needed
mkdir -p
export JH_FQDN="mydomain.com"
export JH_EMAIL="myname@mydomain.com"
export JH_SECRETS="`pwd`/secrets"
export JH_COMMAND="letsencrypt.sh --domain $JH_FQDN --email $JH_EMAIL --volume $JH_SECRETS"
export CERT_SERVER="" # set this to "--staging" if testing script settings
echo $JH_FQDN $JH_EMAIL $JH_SECRETS $CERT_SERVER
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
rm secrets/README
cp secrets/live/$JH_FQDN/fullchain.pem secrets/fullchain.pem
cp secrets/live/$JH_FQDN/privkey.pem secrets/privkey.pem
cp secrets/privkey.pem secrets/$JH_FQDN.key
cp secrets/fullchain.pem secrets/$JH_FQDN.pem
cp secrets/privkey.pem secrets/jupyterhub.key
cp secrets/fullchain.pem secrets/jupyterhub.pem
cp secrets/jupyterhub.key secrets/default.key
cp secrets/jupyterhub.pem secrets/default.pem
