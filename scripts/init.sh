mysql_install_db --user=root --datadir=/var/lib/mysql/1/
mysql_install_db --user=root --datadir=/var/lib/mysql/2/
mysql_install_db --user=root --datadir=/var/lib/mysql/3/
mysql_install_db --user=root --datadir=/var/lib/mysql/4/

mysqld_multi start 1
mysqld_multi start 2
mysqld_multi start 3
mysqld_multi start 4


### These starts do not happen immediate. This sleep is a low tech way to wait. Needs to be replaced with a proper check that loops for all four databases are up
echo "Sleeping for 5..."
sleep 5
mysqld_multi report

echo "Init MariaDB 1..."
mysql -S /var/lib/mysql/1/mysql.sock -P 33061 < ./scripts/mariadb.sql 
echo "Init MariaDB 2..."
mysql -S /var/lib/mysql/2/mysql.sock -P 33062 < ./scripts/mariadb.sql 
echo "Init MariaDB 3..."
mysql -S /var/lib/mysql/3/mysql.sock -P 33063 < ./scripts/mariadb.sql 
echo "Init MariaDB 4..."
mysql -S /var/lib/mysql/4/mysql.sock -P 33064 < ./scripts/mariadb.sql 
sleeo 2
sudo -u maxscale /usr/bin/maxscale &
sleep 2
echo "Setting up replication..."
maxctrl call command mariadbmon reset-replication TheMonitor server1

echo "Init Seed..."
sleep 5
mysql -S /var/lib/mysql/1/mysql.sock -P 33061 < ./scripts/seed.sql

echo "Init.sh complete!"
