# Use an official PHP image with the required version and extensions
FROM php:8.1-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && \
    apt-get install -y libpng-dev libjpeg-dev libfreetype6-dev libzip-dev libicu-dev libxslt-dev zip unzip git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo_mysql zip bcmath intl xsl pdo soap sockets

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

#RUN mkdir -p /var/run/php && chown www-data:www-data /var/run/php

RUN mkdir -p /var/www/magento2
WORKDIR /var/www/magento2

# Install Magento 2.4.6
COPY auth.json /root/.composer/auth.json
RUN composer self-update
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.6 .


EXPOSE 9000

COPY php-fpm.conf /usr/local/etc/php-fpm.conf

# Start services
CMD ["php-fpm"]