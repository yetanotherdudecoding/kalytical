#!/bin/bash
DOCKER_REGISTRY=$1
sudo docker pull alpine:3.6
sudo docker tag alpine:3.6 $DOCKER_REGISTRY/alpine:3.6 
sudo docker push $DOCKER_REGISTRY/alpine:3.6
