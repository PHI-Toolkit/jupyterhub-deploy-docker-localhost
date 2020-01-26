#!/bin/bash
[ -d secrets ] || mkdir secrets
if [[ -f secrets/pg_pass ]]; then
    pg_pass=$(cat secrets/pg_pass)
else
    docker volume rm jupyterhub-db-data
    pg_pass=$(openssl rand -hex 32)
    touch secrets/pg_pass
    echo $pg_pass >> secrets/pg_pass
fi
sed -i -e "s/REPLACE_PG_PASS/`echo $pg_pass`/g" .env
