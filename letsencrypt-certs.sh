#!/bin/bash
# change the values of the exported variables as needed
export JH_FQDN="mydomain.com"
export JH_EMAIL="myname@mydomain.com"
export JH_SECRETS="/path/to/secrets"
export JH_COMMAND="letsencrypt.sh --domain $JH_FQDN --email $JH_EMAIL --volume $JH_SECRETS"
echo $JH_FQDN $JH_EMAIL $JH_SECRETS
docker run --rm -it \
  -p 80:80 \
  -v $JH_SECRETS:/etc/letsencrypt \
  quay.io/letsencrypt/letsencrypt:latest \
  certonly \
  --non-interactive \
  --keep-until-expiring \
  --standalone \
  --standalone-supported-challenges http-01 \
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
cp secrets/fullchain.pem secrets/$JH_FQDN.crt
cp secrets/privkey.pem secrets/jupyterhub.key
cp secrets/fullchain.pem secrets/jupyterhub.crt
rm secrets/*.pem
