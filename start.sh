#!/bin/bash

echo "Running Magento setup:install..."
php /var/www/magento2/bin/magento setup:install \
    --base-url=http://20.51.207.214:9000 \
    --db-host="$DB_HOST" \
    --db-name="$DB_NAME" \
    --db-user="$DB_USER" \
    --db-password="$DB_PASSWORD" \
    --admin-firstname=Admin \
    --admin-lastname=User \
    --admin-email=adnan.sarfraz.2302105@gmail.com \
    --admin-user=admin \
    --admin-password=$ADMIN_PASSWORD \
    --language=en_US \
    --currency=USD \
    --timezone=America/Chicago \
    --use-rewrites=1 \
    --elasticsearch-host=elasticsearch \
    --elasticsearch-port=9200

php-fpm -F
