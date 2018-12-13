#!/bin/bash
if [ -z $1 ]; then
	echo "Sorry, you must specify a container registry entpoint"
	exit
fi
cd ./hdfs/
docker build . -t $regName/kalytical/hdfs:latest
cd ../mysql/
docker build . -t $regName/kalytical/mysql:latest
cd ../streamsets/
docker build . -t $regName/kalytical/streamsets:latest
cd ../jenkins/
docker build . -t $regName/kalytical/jenkins:latest
cd ../kafka/
docker build . -t $regName/kalytical/kafka:latest
cd ../spark/
docker build . -t $regName/kalytical/spark:latest
cd ../nexus/
docker build . -t $regName/kalytical/nexus:latest
cd ../zeppelin/
docker build . -t $regname/kalytical/zeppelin:latest

#Push build docker images to specified registry
for val in $(docker images --format {{.Repository}}:{{.Tag}} | grep kalytical ); do
	docker push $val
done

#Start the platform
kubectl apply -f  master-deployment.yaml
