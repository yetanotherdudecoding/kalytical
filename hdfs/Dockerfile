FROM instance-2:8080/openjdk:8-jdk
USER root
RUN cd /opt
RUN curl -O http://instance-2:8081/repository/raw-artifacts/oss/hadoop-2.7.7.tar.gz
RUN tar -xzf hadoop-2.7.7.tar.gz
COPY hdfs-site.xml hadoop-2.7.7/etc/hadoop/hdfs-site.xml
COPY core-site.xml hadoop-2.7.7/etc/hadoop/core-site.xml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN hadoop-2.7.7/bin/hdfs namenode -format
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
