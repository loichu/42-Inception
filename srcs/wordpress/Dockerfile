FROM debian:buster

ENV WP_PATH=/var/www/html/wordpress

# Install dependencies
RUN apt-get update && apt-get install -y \
    curl wget \
    bash \
    wget \
    unzip \
    sed \
    less \
    net-tools \
    sendmail \
    lsb-release \
    gnupg gnupg2 \
    && rm -rf /var/lib/apt/lists/*

RUN wget -qO - https://packages.sury.org/php/apt.gpg | tee /etc/apt/trusted.gpg.d/php.gpg >/dev/null && \
    echo "deb https://packages.sury.org/php/ $(lsb_release -sc) main" | tee /etc/apt/sources.list.d/sury-php.list

RUN apt-get update && apt-get install -y \
    php8.2-fpm php-cli php8.2-mysql php8.2-xdebug php8.2-curl php8.2-redis \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/*

# Prepare environment
RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
RUN chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp
RUN mkhomedir_helper www-data
RUN mkdir -p ${WP_PATH} /run/php/ && chown -R www-data:www-data ${WP_PATH} /run/php/
RUN touch /var/log/php8.2-fpm.log && \
    chown www-data:www-data /var/log/php8.2-fpm.log && \
    chmod 755 /var/log/php8.2-fpm.log
RUN sed -i s/\\/run\\/php\\/php8.2-fpm.sock/9000/ /etc/php/8.2/fpm/pool.d/www.conf

COPY --chown=www-data:www-data ./docker-entrypoint.sh /
ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Switch to www-data user
USER www-data:www-data
WORKDIR /home/www-data

# Install and configure WordPress
RUN cat <<EOF > wp-cli.yml
path: ${WP_PATH}
EOF
RUN wp core download

EXPOSE 9000
CMD ["php-fpm8.2", "-F"]