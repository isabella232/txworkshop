#!/bin/bash
mysqld_multi start 1
mysqld_multi start 2
mysqld_multi start 3
mysqld_multi start 4
#mysql -S /var/lib/mysql/1/mysql.sock -P 33061 < /usr/share/mysql/install_spider.sql
sudo -u maxscale /usr/bin/maxscale &
maxctrl call command mariadbmon reset-replication TheMonitor server1
exec "$@"
bash
