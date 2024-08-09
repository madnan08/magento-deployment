#!/bin/bash


echo "Running Magento setup:install..."
php /var/www/magento2/bin/magento setup:install \
    --base-url=http://localhost:9000 \
    --db-host="$DB_HOST" \
    --db-name="$DB_NAME" \
    --db-user="$DB_USER" \
    --db-password="$DB_PASSWORD" \
    --admin-firstname=Admin \
    --admin-lastname=User \
    --admin-email=admin@your-domain.com \
    --admin-user=admin \
    --admin-password=admin123 \
    --language=en_US \
    --currency=USD \
    --timezone=America/Chicago \
    --use-rewrites=1


echo "Starting PHP-FPM..."
php-fpm -F
