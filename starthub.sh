#!/bin/bash
echo "Starting up JupyterHub"
echo "..."
docker-compose up -d
echo "Starting up log tracking (Press ctrl-C to stop tracking, JupyterHub will continue running.)"
echo "..."
docker-compose logs --tail='all' -f -t
