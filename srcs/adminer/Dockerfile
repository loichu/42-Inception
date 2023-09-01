FROM debian:buster

ARG PHP_FPM_PORT=9000

ENV ADMINER_PATH=/var/www/html/adminer

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
RUN mkhomedir_helper www-data
RUN mkdir -p ${ADMINER_PATH} /run/php/ && chown -R www-data:www-data ${ADMINER_PATH} /run/php/
COPY --chown=www-data:www-data adminer-4.8.1.php ${ADMINER_PATH}/index.php
RUN touch /var/log/php8.2-fpm.log && \
    chown www-data:www-data /var/log/php8.2-fpm.log && \
    chmod 755 /var/log/php8.2-fpm.log
RUN sed -i s/\\/run\\/php\\/php8.2-fpm.sock/${PHP_FPM_PORT}/ /etc/php/8.2/fpm/pool.d/www.conf

# COPY --chown=www-data:www-data ./docker-entrypoint.sh /
# ENTRYPOINT [ "/docker-entrypoint.sh" ]

# Switch to www-data user
USER www-data:www-data
WORKDIR /home/www-data

# Install and configure WordPress
# RUN cat <<EOF > wp-cli.yml
# path: ${ADMINER_PATH}
# EOF
# RUN wp core download

EXPOSE ${PHP_FPM_PORT}
CMD ["php-fpm8.2", "-F"]