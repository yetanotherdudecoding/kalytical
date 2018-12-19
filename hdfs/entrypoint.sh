#!/bin/bash
/opt/hadoop-2.7.7/bin/hdfs namenode -D &
/opt/hadoop-2.7.7/bin/hdfs datanode -D &
/opt/hadoop-2.7.7/bin/hdfs dfs -mkdir hdfs://localhost:9000/data/
/opt/hadoop-2.7.7/bin/hdfs dfs -chmod 777 hdfs://localhost:9000/data/
while true; do
  sleep 10
done
