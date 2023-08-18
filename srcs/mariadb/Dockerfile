FROM debian:buster

ENV MYSQL_ROOT_PASSWORD=ChangeMe
ENV DB_NAME=wordpress
ENV DB_USER=dbuser
ENV DB_PASS=password
ENV DB_HOST=mariadb

RUN apt-get update -y && apt-get install -y \
    bash \
    mariadb-server mariadb-client \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /run/mysqld /var/lib/mysql && \
    chown -R mysql:mysql /run/mysqld /var/lib/mysql && \
    sed -i s/127.0.0.1/0.0.0.0/ /etc/mysql/mariadb.conf.d/50-server.cnf
COPY ./docker-entrypoint.sh /docker-entrypoint.sh
ENTRYPOINT ["/docker-entrypoint.sh"]

EXPOSE 3306
CMD ["mysqld", "--user=mysql", "--datadir=/var/lib/mysql"]