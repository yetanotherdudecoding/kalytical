#!/bin/bash
sqlPass=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $11}')
mysql -uroot -p$sqlPass --connect-expired-password < setup.sql

