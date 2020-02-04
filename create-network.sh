#!/bin/bash
source .env
if [ ! "$(docker network ls | grep $DOCKER_NETWORK_NAME)" ]; then
  echo "Creating nginx-proxy network ..."
  docker network create $DOCKER_NETWORK_NAME
else
  echo "$DOCKER_NETWORK_NAME network exists."
fi
