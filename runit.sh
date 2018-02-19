docker build . -t txworkshop


docker run --name txworkshop -d -it -h txworkshop txworkshop /bin/bash

#docker cp mariadb.sql mdb1:/root

#docker cp server2.cnf mdb2:/etc/my.cnf.d/server.cnf
#docker cp server3.cnf mdb3:/etc/my.cnf.d/server.cnf

#docker exec -it mdb1 /etc/init.d/mysql start
#docker exec -i  mdb1 mysql < mariadb.sql

