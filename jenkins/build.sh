#!/bin/bash
DOCKER_REGISTRY=$1
cd jenkins
chmod +x ./getJenkins.sh 
./getJenkins.sh
cd docker
sed -i 's/2.121.1/2.150.1/g' Dockerfile
sed -i 's/5bb075b81a3929ceada4e960049e37df5f15a1e3cfc9dc24d749858e70b48919/7a38586d5a3a1a83498809a83715728bb2f01b58a7dd3a88366f076efdaf6669/g' Dockerfile
docker build . -t $DOCKER_REGISTRY/jenkins:latest && docker push $DOCKER_REGISTRY/jenkins:latest
