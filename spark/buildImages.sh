#!/bin/bash
curl -L https://archive.apache.org/dist/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz -o spark_2.3.1.tar.gz && \
tar -xzf spark_2.3.1.tar.gz && \
rm spark_2.3.1.tar.gz && \
cd spark-2.3.1-bin-hadoop2.7 && \ 
docker build . -t instance-1:8080/spark:2.3.1 -f kubernetes/dockerfiles/spark/Dockerfile && \
docker push instance-1:8080/spark:2.3.1
cd .. && rm -rf spark-2.3.1-bin-without-hadoop
