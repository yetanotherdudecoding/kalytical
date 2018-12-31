ARG DOCKER_REGISTRY=instance-1.us-east1-b.c.sandbox-224519.internal:8080
FROM ${DOCKER_REGISTRY}/centos:7
USER root
WORKDIR /opt
RUN yum install wget -y
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
RUN yum install mysql57-community-release-el7-9.noarch.rpm -y && yum install mysql-server -y
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
COPY setup.sql setup.sql
COPY configure.sh configure.sh
RUN chmod +x configure.sh setup.sql
USER mysql
#RUN adduser mysql -u 1537 -U
ENTRYPOINT ["sh", "-c", "/entrypoint.sh"]
#Default mysqlport
EXPOSE 3306
