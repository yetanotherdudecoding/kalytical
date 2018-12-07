curl -O http://apache.mirrors.lucidnetworks.net/hadoop/common/hadoop-2.7.7/hadoop-2.7.7.tgz
Then extract.
Copy in the *xml files to hadoophome/etc/hadoop
Add hadoop home to path
https://hadoop.apache.org/docs/stable/hadoop-project-dist/hadoop-common/SingleCluster.html
bin/hdfs namenode -format
bin/hdfs namenode &
bin/hdfs datanode &


