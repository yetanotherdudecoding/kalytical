#!/bin/bash
/opt/hadoop-2.7.7/bin/hdfs namenode -D &
/opt/hadoop-2.7.7/bin/hdfs datanode -D &
/opt/hadoop-2.7.7/bin/hdfs dfsadmin -report
status=$?
while [ "$status" != "0" ]; do
       sleep 5
       /opt/hadoop-2.7.7/bin/hdfs dfsadmin -report
      status=$?
      echo "status is:"$status
done
#Now we can create our default data directories
/opt/hadoop-2.7.7/bin/hdfs dfs -mkdir hdfs://localhost:9000/data
/opt/hadoop-2.7.7/bin/hdfs dfs -chmod 777 hdfs://localhost:9000/data
/opt/hadoop-2.7.7/bin/hdfs dfs -mkdir hdfs://localhost:9000/data/{raw,prepared,published}
/opt/hadoop-2.7.7/bin/hdfs dfs -chmod 777 hdfs://localhost:9000/data/{raw,prepared,published}
while true; do
       sleep 10
done
