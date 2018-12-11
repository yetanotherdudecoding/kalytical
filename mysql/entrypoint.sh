#!/bin/bash
#Start mysql
/usr/bin/mysqld_pre_systemd
/usr/sbin/mysqld --daemonize --pid-file=/var/run/mysqld/mysqld.pid
/opt/configure.sh
while true; do
sleep 100
done
