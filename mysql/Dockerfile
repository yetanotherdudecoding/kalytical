FROM centos:7
USER root
RUN yum install wget -y
RUN wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
RUN yum install mysql57-community-release-el7-9.noarch.rpm -y && sudo yum install mysql-server -y
#RUN systemctl enable mysqld && sudo systemctl start mysqld
COPY setup.sql setup.sql
COPY configure.sh configure.sh
#RUN configure.sh
