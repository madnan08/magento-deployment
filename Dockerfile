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
    chown -R www-data:www-data /run/php && \
    chmod u+w /root/.composer

# Remove auth.json file if it exists
RUN if [ -f /root/.composer/auth.json ]; then rm /root/.composer/auth.json; fi
COPY auth.json /root/.composer/auth.json

# Set working directory
WORKDIR /var/www/magento2
RUN composer self-update && \
    composer create-project --repository-url=https://repo.magento.com/ magento/project-community-edition .

RUN find var generated vendor pub/static pub/media app/etc -type f -exec chmod g+w {} +
    
# Copy configuration files
COPY php-fpm.conf /usr/local/etc/php-fpm.conf
COPY php.ini /usr/local/etc/php/conf.d/


# Expose port for PHP-FPM
EXPOSE 9000

COPY start.sh /usr/local/bin/start.sh
RUN chmod +x /usr/local/bin/start.sh \
    && chown www-data:www-data /usr/local/bin/start.sh

CMD ["/usr/local/bin/start.sh"]
