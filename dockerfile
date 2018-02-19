FROM centos:7
RUN yum -y update
RUN yum -y install wget mysql sudo which epel-release python-pip gcc python-devel mysql-devel
RUN yum -y install python-pip
RUN pip install --upgrade pip
RUN pip install MySQL-python

## Get and install Maxscale
RUN wget https://downloads.mariadb.com/MaxScale/2.2.1/rhel/7/x86_64/maxscale-2.2.1-1.rhel.7.x86_64.rpm
RUN yum -y install maxscale-2.2.1-1.rhel.7.x86_64.rpm
COPY scripts/maxscale.cnf /etc/maxscale.cnf

## Install latest Mariadb
WORKDIR /root
RUN wget https://downloads.mariadb.com/MariaDB/mariadb-10.2.12/yum/rhel/mariadb-10.2.12-rhel-7-x86_64-rpms.tar
RUN tar xvf mariadb-10.2.12-rhel-7-x86_64-rpms.tar
RUN mariadb-10.2.12-rhel-7-x86_64-rpms/setup_repository
RUN yum -y install MariaDB-server

RUN mkdir -p /usr/local/mysql/{1,2,3,4}/data

RUN mkdir -p /var/lib/mysql/{1,2,3,4}

RUN touch /var/log/mysqld{1,2,3,4}.log
RUN chmod o-r /var/log/mysqld{1,2,3,4}.log

COPY scripts/*    /root/scripts/

RUN mkdir -p /root/scripts

RUN chmod +x /root/scripts/init.sh
RUN chmod +x /root/scripts/docker-entrypoint.sh
RUN chmod +x /root/scripts/startup.sh

RUN mkdir -p /var/run/mysqld/

## Cleanup
RUN sudo rm -R /root/mariadb-10.2.12-rhel-7-x86_64-rpms*

##RUN /root/scripts/init.sh

#STOPSIGNAL SIGKILL
ENTRYPOINT ["scripts/docker-entrypoint.sh"]
