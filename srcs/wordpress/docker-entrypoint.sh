#!/bin/bash
set -e

if [ ! -f "${WP_PATH}/wp-config.php" ]; then
    wp config create --skip-check \
        --dbname=${DB_NAME} \
        --dbuser=${DB_USER} \
        --dbpass=${DB_PASS} \
        --dbhost=${DB_HOST}
fi

exec "$@"