FROM debian:12

# Default config values
ENV WP_PATH=/var/www/html/wordpress
ENV DB_NAME=wordpress
ENV DB_USER=dbuser
ENV DB_PASS=password
ENV DB_HOST=mariadb

# Install dependencies
RUN apt-get update && apt-get install -y \
  curl \
  bash \
  wget \
  unzip \
  net-tools \
  lsb-release \
  gnupg gnupg2 \
  php-fpm php-cli php-mysql php-xdebug php-curl \
  mariadb-client \
  && rm -rf /var/lib/apt/lists/*

# Prepare environment
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkhomedir_helper www-data
RUN mkdir -p ${WP_PATH} && chown -R www-data:www-data ${WP_PATH}
RUN touch /var/log/php8.2-fpm.log && \
    chown www-data:www-data /var/log/php8.2-fpm.log && \
    chmod 755 /var/log/php8.2-fpm.log
COPY --chown=www-data:www-data ./docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Switch to www-data user
USER www-data:www-data
WORKDIR /home/www-data

# Install and configure WordPress
RUN cat <<EOF > wp-cli.yml
path: /var/www/html/wordpress
EOF
RUN wp core download

EXPOSE 9000
CMD ["php-fpm8.2", "-F"]