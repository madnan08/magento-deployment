#!/bin/bash

# Change directory to where Magento should be installed
cd /var/www/magento2

# Set up Composer authentication for accessing Magento repository
echo "Setting up Composer authentication..."
echo '{
    "http-basic": {
        "repo.magento.com": {
            "username": "'"${PUBLIC_KEY}"'",
            "password": "'"${PRIVATE_KEY}"'"
        }
    }
}' > /root/.composer/auth.json

# Update Composer to the latest version
echo "Updating Composer..."
composer self-update

# Create Magento project
echo "Creating Magento project..."
composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.6 .

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

exec /usr/bin/supervisord -c /etc/supervisor/supervisord.conf
