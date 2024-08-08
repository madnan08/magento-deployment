#!/bin/bash


echo "Waiting for MySQL to be ready..."
until mysql -h "$DB_HOST" -u "$DB_USER" -p"$DB_PASSWORD" -e "show databases;" > /dev/null 2>&1; do
    echo -n "."
    sleep 1
done
echo "MySQL is ready."


if [ ! -f /var/www/magento2/app/etc/env.php ]; then
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
fi


echo "Starting PHP-FPM..."
php-fpm -F
