#!/bin/bash
DOCKER_REPO=$1
ARTIFACT_REPO=$2
curl $ARTIFACT_REPO -o spark_2.3.1.tar.gz
tar -xzf spark_2.3.1.tar.gz
rm spark_2.3.1.tar.gz
cd spark-2.3.1-bin-hadoop2.7
docker build . -t $DOCKER_REPO/spark:2.3.1 -f kubernetes/dockerfiles/spark/Dockerfile
docker push $DOCKER_REPO/spark:2.3.1
cd .. && rm -rf spark-2.3.1-bin-without-hadoop
