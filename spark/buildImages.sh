#!/bin/bash
curl -L https://archive.apache.org/dist/spark/spark-2.4.0/spark-2.4.0-bin-without-hadoop.tgz -o spark_2.4.0.tar.gz && \
tar -xzf spark_2.4.0.tar.gz && \
rm spark_2.4.0.tar.gz && \
cd spark-2.4.0-bin-without-hadoop && \ 
docker build . -t instance-1:8080/spark:2.4.0 -f kubernetes/dockerfiles/spark/Dockerfile && \
docker push instance-1:8080/spark:2.4.0
cd .. && rm -rf spark-2.4.0-bin-without-hadoop
