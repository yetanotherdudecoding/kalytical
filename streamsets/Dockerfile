FROM instance-2:8080/openjdk:8-jdk
USER root
ENV STREAMSET_VER=streamsets-datacollector-all-3.6.1.tgz
WORKDIR /opt
RUN curl -u admin:rwzB8ff@tuil -O http://instance-2:8081/repository/raw-artifacts/oss/streamsets-datacollector-all-3.6.1.tgz
RUN tar -xzf streamsets-datacollector-all-3.6.1.tgz
EXPOSE 18630
