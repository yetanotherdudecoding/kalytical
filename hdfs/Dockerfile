FROM instance-1.us-east1-b.c.sandbox-224519.internal:8080:8080/openjdk:8-jdk
USER root
WORKDIR /opt
RUN apt-get update -y && apt-get install vim net-tools telnet -y
RUN curl -O http://instance-2:8081/repository/raw-artifacts/oss/hadoop-2.7.7.tar.gz
RUN tar -xzf hadoop-2.7.7.tar.gz
COPY hdfs-site.xml hadoop-2.7.7/etc/hadoop/hdfs-site.xml
COPY core-site.xml hadoop-2.7.7/etc/hadoop/core-site.xml
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
RUN hadoop-2.7.7/bin/hdfs namenode -format
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]

#Master namenode webui
EXPOSE 50070
#Namenode IPC - bare minimum for external hosts to connect to hdfs
EXPOSE 9000
EXPOSE 8020
#Insecure webui
EXPOSE 50075
#Secure webui
EXPOSE 50475
#Datanode data transfer
EXPOSE 50010
#IPC between data nodes
EXPOSE 50020
#Secondary namenode connection
EXPOSE 50090
