#!/bin/sh
set -e

# init Mariadb data directory
if [ ! -f "/var/lib/mysql/done" ]; then
    echo "Init MariaDB..."

    mysql_install_db --user=mysql --datadir=/var/lib/mysql

    # start mariadb in the background
    mysqld --user=mysql --datadir=/var/lib/mysql --skip-networking=ON &

    mysql_pid=$!

    # Wait for MariaDB to become available
    until mysqladmin -u root ping >/dev/null 2>&1; do
        sleep 1
    done

    mysql -uroot -hlocalhost --database=mysql <<-EOSQL
        ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
        GRANT ALL PRIVILEGES ON *.* TO 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}' ;
        DROP DATABASE IF EXISTS test ;
        CREATE DATABASE IF NOT EXISTS ${DB_NAME} ;
        CREATE USER IF NOT EXISTS '${DB_USER}'@'%' IDENTIFIED BY '${DB_PASS}' ;
        GRANT ALL PRIVILEGES ON ${DB_NAME}.* TO '${DB_USER}'@'%' ;
        FLUSH PRIVILEGES ; 
EOSQL
    #    DROP DATABASE IF EXISTS test ;
    #     CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE} ;
    #     CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}' ;
    #     GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* TO '${MYSQL_USER}'@'%' ;

    kill "$mysql_pid"

    # Wait for the MariaDB process to stop completely
    wait "$mysql_pid"

    touch /var/lib/mysql/done
fi

echo "MariaDB is ready"

exec "$@"