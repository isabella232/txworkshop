#/bin/bash

#
# Executed through MaxScale, automatically distributed across all servers
#

mysql -h 127.0.0.1 -P 3306 -u maxuser -pmaxpwd test -e 'SET GLOBAL session_track_system_variables=last_gtid'
