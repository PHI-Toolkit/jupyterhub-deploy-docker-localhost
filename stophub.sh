#!/bin/bash
docker-compose down
docker stop $(docker ps -a | grep jupyter- | awk '{print $1}')
docker rm $(docker ps -a | grep jupyter- | awk '{print $1}')
