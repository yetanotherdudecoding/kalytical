#!/bin/bash
/opt/hadoop-2.7.7/bin/hdfs namenode -D &
/opt/hadoop-2.7.7/bin/hdfs datanode -D &
/opt/hadoop-2.7.7/bin/hdfs dfs -chmod 777 /
while true; do
  sleep 10
done
