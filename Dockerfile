FROM php:8.1-fpm

# Environment variable
ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies and PHP extensions
RUN apt-get update && \
    apt-get install -y \
    nginx \
    supervisor \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libzip-dev \
    libicu-dev \
    libxslt-dev \
    zip \
    unzip \
    git && \
    docker-php-ext-configure gd --with-freetype --with-jpeg && \
    docker-php-ext-install gd pdo_mysql zip bcmath intl xsl pdo soap sockets

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer

# Create necessary directories and set permissions
RUN mkdir -p /var/www/magento2 && \
    chown -R www-data:www-data /var/www/magento2 && \
    mkdir -p /run/php && \
    chown -R www-data:www-data /run/php

WORKDIR /var/www/magento2

COPY auth.json /root/.composer/auth.json

# Copy configuration files
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY nginx.conf /etc/nginx/nginx.conf
COPY php.ini /usr/local/etc/php/conf.d/
COPY supervisord.conf /etc/supervisor/supervisord.conf

# Expose port for PHP-FPM
EXPOSE 80 9000

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh \
    && chown www-data:www-data /usr/local/bin/start.sh

CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/supervisord.conf"]
