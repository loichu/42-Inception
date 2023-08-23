#!/bin/bash
set -e

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    wp config create \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASS} \
        --dbhost=${DB_HOST} \
        --extra-php <<PHP
define( 'WP_REDIS_HOST', '${WP_REDIS_HOST}' );
define( 'WP_REDIS_PORT', 6379 );
define( 'WP_REDIS_PREFIX', 'inception' );
define( 'WP_REDIS_DATABASE', 0 );
define( 'WP_REDIS_TIMEOUT', 5 );
define( 'WP_REDIS_READ_TIMEOUT', 5 );
PHP

    wp core install \
        --url=${WP_URL} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN_USER} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

    wp user create ${WP_USER} ${WP_EMAIL} \
        --user_pass=${WP_PASSWORD}

    wp plugin install redis-cache --activate
    wp redis enable
fi

exec "$@"