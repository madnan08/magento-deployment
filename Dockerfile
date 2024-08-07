# Use an official PHP image with the required version and extensions
FROM php:8.1-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

RUN apt-get update && \
    apt-get install -y \
    nginx \
    libicu-dev \
    libzip-dev \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    unzip \
    git \
    libxslt-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libonig-dev \
    libmcrypt-dev \
    libsqlite3-dev \
    && rm -rf /var/lib/apt/lists/*

# Install PHP extensions
RUN docker-php-ext-install -j$(nproc) gd intl xsl zip bcmath opcache pdo pdo_mysql \
    && docker-php-ext-install ctype curl dom fileinfo filter hash iconv json \
    && docker-php-ext-install libxml mbstring openssl pcre simplexml soap sockets sodium tokenizer xmlwriter zlib


COPY auth.json /root/.composer/auth.json

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer
# Install Composer
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

RUN chmod +x /usr/bin/composer

RUN mkdir -p /var/www/magento2
WORKDIR /var/www/magento2
# Install Magento 2.4.6
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

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
CMD ["php-fpm"]