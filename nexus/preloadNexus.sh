#!/bin/bash
DOCKER_REGISTRY=$1
NEXUS_RAW_URL=$2

IMAGES=('alpine:3.6' 'sonatype/nexus3' 'openjdk:8-jdk' 'centos:7' 'jupyter/all-spark-notebook')

for i in ${IMAGES[@]}; do
	sudo docker pull $i
	sudo docker tag $i $DOCKER_REGISTRY/$i
	sudo docker push $DOCKER_REGISTRY/$i
done


ARTIFACT_LIST=('http://ftp.naz.com/apache/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tar.gz' 'http://mirrors.ocf.berkeley.edu/apache/spark/spark-2.3.1/spark-2.3.1-bin-hadoop2.7.tgz' 'https://archives.streamsets.com/datacollector/3.6.1/tarball/streamsets-datacollector-all-3.6.1.tgz')

for i in ${ARTIFACT_LIST[@]}; do
        ITEM_NAME=$(echo $i | awk 'BEGIN {FS="/"}; {print $NF}')
	echo $ITEM_NAME
	if [ ! -r $ITEM_NAME ]; then
		curl -LO $i
	fi
	curl -v -u admin:admin123 --upload-file $ITEM_NAME $NEXUS_RAW_URL/raw-arifacts/oss/$ITEM_NAME
done

#For sample purposes
tar -xzvf spark-2.3.1-bin-hadoop2.7.tgz spark-2.3.1-bin-hadoop2.7/examples/jars/spark-examples_2.11-2.3.1.jar
curl -v -u admin:admin123 --upload-file spark-2.3.1-bin-hadoop2.7/examples/jars/spark-examples_2.11-2.3.1.jar $NEXUS_RAW_URL/dataproducts/examples/spark-examples_2.11-2.3.1.jar
rm -rf spark-2.3.1-bin-hadoop2.7
