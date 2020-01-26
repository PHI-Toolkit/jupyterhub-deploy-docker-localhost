#!/bin/bash
[ -d secrets ] || mkdir secrets
if [[ -f secrets/proxy_token ]]; then
    proxy_token=$(cat secrets/proxy_token)
else
    proxy_token=$(openssl rand -hex 32)
    touch secrets/proxy_token
    echo $proxy_token >> secrets/proxy_token
fi
sed -i -e "s/REPLACE_TOKEN/`echo $proxy_token`/g" .env
