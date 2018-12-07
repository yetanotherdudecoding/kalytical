FROM bradboxmobile:8082/openjdk:8-jdk
USER root
RUN cd /opt
RUN curl -u admin:admin123 http://bradboxmobile:8081/repository/raw-artifacts/oss/streamsets-datacollector-all-3.6.0.tgz
RUN tar -xzf streamsets-datacollector-all-3.6.0.tgz
