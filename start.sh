#!/bin/bash

cd /var/www/magento2
echo "Running Magento setup:install..."
php bin/magento setup:install \
    --base-url=${MAGENTO_HOST} \
    --db-host=${DB_HOST} \
    --db-name=${DB_NAME} \
    --db-user=${DB_USER} \
    --db-password=${DB_PASSWORD} \
    --admin-firstname=Admin \
    --admin-lastname=User \
    --admin-email=adnan.sarfraz.2302105@gmail.com \
    --admin-user=${MAGENTO_USERNAME} \
    --admin-password=${MAGENTO_PASSWORD} \
    --language=en_US \
    --currency=USD \
    --timezone=America/Chicago \
    --use-rewrites=1 \
    --elasticsearch-host=${ELASTICSEARCH_HOST} \
    --elasticsearch-port=9200

php-fpm -F
