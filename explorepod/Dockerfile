FROM centos:7
WORKDIR /root
RUN yum update -y && yum install which git java-1.8.0-openjdk telnet net-utils gcc bind-utils centos-release-scl kubectl -y && yum install rh-python35 -y && scl enable rh-python35 bash
RUN curl -O http://instance-1:8081/repository/raw-artifacts/oss/spark-2.3.1-bin-hadoop2.7.tgz && tar -xzvf spark-2.3.1-bin-hadoop2.7.tgz
RUN curl -O http://instance-1:8081/repository/raw-artifacts/oss/hadoop-2.7.7.tar.gz && tar -xzvf hadoop-2.7.7.tar.gz
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64/jre
COPY examples ./examples
