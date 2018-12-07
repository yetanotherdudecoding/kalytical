set global validate_password_policy=LOW;
alter user root@localhost identified by 'password';
GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;

drop database if exists origin;
drop database if exists target;
drop database if exists test;

create database origin;
create database target;

create table origin.src_records (id bigint not null unique, name varchar(128), eye_color varchar(64));
create table target.rep_recrods (id bigint not null unique, name varchar(128), eye_color varchar(64));


