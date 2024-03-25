# Use the official PHP 8.2 FPM base image
FROM php:8.2-fpm

# Update package lists and install libmcrypt-dev and oniguruma
RUN apt-get update -y \
    && apt-get install -y zip unzip p7zip git \
    && apt-get install -y libmcrypt-dev libonig-dev \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install PHP extensions
RUN docker-php-ext-install pdo mbstring

# Set working directory
WORKDIR /var/www/html

# Copy application files
COPY . /var/www/html

# Set Composer to allow superuser

ENV COMPOSER_ALLOW_SUPERUSER=1

# Install dependencies using Composer
RUN composer install --no-scripts --no-autoloader

# Expose port 9000 (default for PHP-FPM)
EXPOSE 9000

# Start PHP-FPM
CMD ["php-fpm"]
 