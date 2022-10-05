#!/bin/bash

set -exo

if [[ -z $1 ]]; then
  VER=$(date +"%Y.%m.%d")
else
  VER=$1
fi
docker tag bbuitenhuis/lucyoscar19:latest bbuitenhuis/lucyoscar19:release
docker tag bbuitenhuis/lucyoscar19:latest bbuitenhuis/lucyoscar19:$VER
#docker login --username=$DOCKERHUB_USERNAME --password=$DOCKERHUB_PASSWORD
docker push bbuitenhuis/lucyoscar19:$VER
docker push bbuitenhuis/lucyoscar19:latest
docker push bbuitenhuis/lucyoscar19:release

