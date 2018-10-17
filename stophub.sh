#!/bin/bash
if [[ "$(docker ps -a | grep jupyter- | awk '{print $1}')" != "" ]]; then
    docker stop $(docker ps -a | grep jupyter- | awk '{print $1}')
    docker rm $(docker ps -a | grep jupyter- | awk '{print $1}')
fi
docker-compose down
