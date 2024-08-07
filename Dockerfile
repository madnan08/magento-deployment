# Use an official PHP image with the required version and extensions
FROM php:8.1-fpm

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
    nginx \
    libzip-dev \
    unzip \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libxml2-dev \
    libicu-dev \
    libxslt1-dev \
    libonig-dev \
    libcurl4-openssl-dev \
    libbz2-dev \
    libmcrypt-dev \
    libsqlite3-dev \
    git \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install gd \
    && docker-php-ext-install bcmath intl soap zip curl mysqli xml xsl \
    && pecl install redis \
    && docker-php-ext-enable redis

COPY auth.json /root/.composer/auth.json

RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer \
    && chmod +x /usr/local/bin/composer
# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

RUN chmod +x /usr/bin/composer

RUN mkdir -p /var/www/magento2
WORKDIR /var/www/magento2
# Install Magento 2.4.6
RUN composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

# Set permissions for Magento directories
RUN chown -R www-data:www-data /var/www/magento2 \
    && chmod -R 755 /var/www/magento2

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start PHP-FPM server
CMD ["php-fpm"]