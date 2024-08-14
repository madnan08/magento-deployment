#!/bin/bash

# Change directory to where Magento should be installed
cd /var/www/magento2

# Run Magento setup
echo "Running Magento setup:install..."
php bin/magento setup:install \
    --base-url=${MAGENTO_HOST} \
    --db-host=${DB_HOST} \
    --db-name=${DB_NAME} \
    --db-user=${DB_USER} \
    --db-password=${DB_PASSWORD} \
    --admin-firstname=Admin \
    --admin-lastname=User \
    --admin-email=${ADMIN_EMAIL} \
    --admin-user=${MAGENTO_USERNAME} \
    --admin-password=${MAGENTO_PASSWORD} \
    --language=en_US \
    --currency=USD \
    --timezone=America/Chicago \
    --use-rewrites=1 \
    --elasticsearch-host=${ELASTICSEARCH_HOST} \
    --elasticsearch-port=9200 \
    --search-engine=elasticsearch7

php -S 0.0.0.0:80 -t pub
