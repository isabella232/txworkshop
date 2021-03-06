#!/bin/bash

#
# Creates a table and starts inserting and reading values from it outside of a
# transaction with autocommit=1.
#

mysql -u maxuser -pmaxpwd -h 127.0.0.1 -P 3306 -e "CREATE OR REPLACE TABLE test.t1 (id int);"

i=0

while [ $? -eq 0 ]
do
    echo "INSERT INTO test.t1 VALUES ($i);"
    echo "select 'Transaction # $i';"
    i=$((i+1))
done | mysql -u maxuser -pmaxpwd -h 127.0.0.1 -P 3306
