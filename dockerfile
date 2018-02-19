FROM centos:7
RUN yum -y update
RUN yum -y install wget mysql sudo which epel-release python-pip gcc python-devel mysql-devel
RUN yum -y install python-pip
RUN pip install --upgrade pip
RUN pip install MySQL-python

## Get and install Maxscale
RUN wget https://downloads.mariadb.com/MaxScale/2.2.1/rhel/7/x86_64/maxscale-2.2.1-1.rhel.7.x86_64.rpm
RUN yum -y install maxscale-2.2.1-1.rhel.7.x86_64.rpm
COPY maxscale.cnf /etc/maxscale.cnf

## Install latest Mariadb
WORKDIR /root
RUN wget https://downloads.mariadb.com/MariaDB/mariadb-10.2.12/yum/rhel/mariadb-10.2.12-rhel-7-x86_64-rpms.tar
RUN tar xvf mariadb-10.2.12-rhel-7-x86_64-rpms.tar
RUN mariadb-10.2.12-rhel-7-x86_64-rpms/setup_repository
RUN yum -y install MariaDB-server

RUN mkdir -p /usr/local/mysql/1/data /usr/local/mysql/2/data /usr/local/mysql/3/data /usr/local/mysql/4/data

RUN mkdir -p /var/lib/mysql/{1,2,3,4}

##
RUN touch /var/log/mysqld{1,2,3,4}.log
RUN chmod o-r /var/log/mysqld{1,2,3,4}.log


COPY scripts/my.cnf /etc/my.cnf
COPY scripts/maxscale.cnf /etc/maxscale.cnf
COPY scripts/masking_rules.json /etc
RUN mkdir -p /root/scripts
COPY scripts/mariadb.sql /root/scripts
COPY scripts/seed.sql    /root/scripts
COPY scripts/startup.sh  /root/
COPY scripts/init.sh     /root/scripts
RUN chmod +x /root/scripts/init.sh
RUN chmod +x /root/startup.sh

RUN mkdir -p /var/run/mysqld/

## Cleanup
RUN sudo rm -R /root/mariadb-10.2.12-rhel-7-x86_64-rpms*

RUN /root/scripts/init.sh

#STOPSIGNAL SIGKILL
#ADD mariadb.sql /docker-entrypoint-initdb.d/mariadb.sql
