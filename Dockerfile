# Use an official PHP image with the required version and extensions
FROM php:8.1-fpm

# Install system dependencies and PHP extensions
RUN apt-get update && apt-get install -y \
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

# Set working directory
WORKDIR /var/www/magento2

# Install Composer
COPY --from=composer:2 /usr/bin/composer /usr/bin/composer

ARG MAGENTO_PUBLIC_KEY
ARG MAGENTO_PRIVATE_KEY

# Install Magento 2.4.6
RUN composer config http-basic.repo.magento.com $MAGENTO_PUBLIC_KEY $MAGENTO_PRIVATE_KEY \
    && composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition=2.4.6 .

# Set permissions for Magento directories
RUN chown -R www-data:www-data /var/www/magento2 \
    && chmod -R 755 /var/www/magento2

# Copy Nginx configuration
COPY nginx.conf /etc/nginx/nginx.conf

# Expose port 80
EXPOSE 80

# Start PHP-FPM server
CMD ["php-fpm"]