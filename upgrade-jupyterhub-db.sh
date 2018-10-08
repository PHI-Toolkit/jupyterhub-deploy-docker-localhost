#!/bin/bash
# run this script after upgrading jupyterhub
# use only for postgres backend
docker exec jupyterhub jupyterhub upgrade-db
