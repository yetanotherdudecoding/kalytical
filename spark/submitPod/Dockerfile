ARG DOCKER_REGISTRY=instance-1.us-east1-b.c.sandbox-224519.internal:8080
FROM ${DOCKER_REGISTRY}/centos:7
WORKDIR /root
ARG SPARK_ARTIFACT_URL=http://instance-1.us-east1-b.c.sandbox-224519.internal/repository/raw-artifacts/oss/spark-2.3.1-bin-hadoop2.7.tgz
RUN yum update -y && yum install which git java-1.8.0-openjdk telnet net-utils gcc bind-utils centos-release-scl kubectl -y && yum install rh-python35 -y && scl enable rh-python35 bash
RUN curl -O ${SPARK_ARTIFACT_URL} && tar -xzvf spark*.tgz
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-1.8.0.191.b12-1.el7_6.x86_64/jre
WORKDIR /
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
