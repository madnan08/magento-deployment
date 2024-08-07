# Use an official PHP image with the required version and extensions
FROM php:8.1-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev libxslt-dev zip unzip git nginx && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo_mysql zip bcmath intl xsl pdo soap sockets



RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

RUN mkdir -p /var/www/magento2
WORKDIR /var/www/magento2
# Install Magento 2.4.7-p1
COPY auth.json /root/.composer/auth.json
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.7-p1 .

# Set permissions for Magento directories
RUN chown -R www-data:www-data /var/www/magento2 \
    && chmod -R 755 /var/www/magento2 \
    && find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} + \
    && find var generated vendor pub/static pub/media app/etc -type d -exec chmod g+ws {} + \
    && chmod u+x bin/magento

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start PHP-FPM server
CMD service nginx start && php-fpm