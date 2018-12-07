#!/bin/bash
rootDeploy="/apps"
runUser=$(whoami)
sudo usermod -aG wheel zerodown524
sudo setenforce 0
sudo systemctl disable firewalld && sudo systemctl stop firewalld
sudo sed -i 's/^SELINUXTYPE=enforcing$/SELINUX=permissive/' /etc/selinux/config

if [ ! -d "$rootDeploy" ]; then
	sudo mkdir $rootDeploy && sudo chown -R $runUser $rootDeploy && sudo chmod +w $rootDeploy
fi

#Install packages
#sudo yum update -y
sudo yum install git telnet wget docker java-1.8.0-openjdk -y

echo "Install mysql server..."
wget https://dev.mysql.com/get/mysql57-community-release-el7-9.noarch.rpm
sudo yum install mysql57-community-release-el7-9.noarch.rpm -y && sudo yum install mysql-server -y
sudo systemctl enable mysqld && sudo systemctl start mysqld
sqlPass=$(sudo grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')

echo "Implementing test sql schemas"
mysql -uroot -p$sqlPass --connect-expired-password < setup.sql

#Install streamsets
cd $rootDeploy
echo "Downloading/unpacking streamsets"
curl -O https://archives.streamsets.com/datacollector/3.6.0/tarball/streamsets-datacollector-all-3.6.0.tgz
tar -xzf streamsets-datacollector-all-3.6.0.tgz
sed -i 's/18630/80/g' $rootDeploy/streamsets-datacollector-3.6.0/etc/sdc.properties
sudo sh -c 'cat <<EOF >> /etc/security/limits.conf
* hard nofile 32768
* soft nofile 32768
EOF'
echo "Mysql password is: password"
