# # Use the official PHP 8.2 FPM base image
# FROM php:8.2-fpm

# # Update package lists and install system dependencies
# RUN apt-get update && \
#     apt-get install -y \
#     zip \
#     unzip \
#     p7zip \
#     git \
#     libmcrypt-dev \
#     libonig-dev && \
#     apt-get clean && \
#     rm -rf /var/lib/apt/lists/*

# # Install Composer
# RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
#     rm -rf /tmp/* # Clean up Composer installer

# # Set working directory
# WORKDIR /var/www/html

# # Copy only the composer files first
# # COPY composer.json composer.lock /var/www/html/
# COPY . /var/www/html

# # Install dependencies using Composer
# RUN composer install --no-scripts --no-autoloader

# # Copy the application files
# #COPY . /var/www/html

# # Set Composer to allow superuser
# ENV COMPOSER_ALLOW_SUPERUSER=1

# # Install PHP extensions
# RUN docker-php-ext-install pdo mbstring

# # Expose port 9000 (default for PHP-FPM)
# EXPOSE 8000

# # Start PHP-FPM
# CMD ["php-fpm"]


# Use PHP official image
FROM php:8.2-cli
# Set working directory
WORKDIR /var/www/html
# Install dependencies
RUN apt-get update && apt-get install -y \
    git \
    unzip \
    && apt-get clean && rm -rf /var/lib/apt/lists/*
# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
# Copy composer files and install dependencies

COPY composer.json composer.lock ./

RUN composer install --no-scripts --no-autoloader
# Copy Laravel application files
COPY . .
# Generate optimized autoload files
RUN composer dump-autoload --optimize
# Expose port 8000 (or any other port you prefer)
EXPOSE 8000
# Command to run the built-in PHP server
CMD ["php", "artisan", "serve", "--host", "0.0.0.0", "--port", "8000"]







