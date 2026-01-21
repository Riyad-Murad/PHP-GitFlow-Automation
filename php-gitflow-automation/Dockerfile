FROM php:8.4-apache

# Set working directory
WORKDIR /var/www/html

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git unzip libzip-dev libonig-dev libxml2-dev zip curl nano \
    # Needed for migrations
    default-mysql-client \ 
    # Enable necessary PHP extensions
    && docker-php-ext-install pdo pdo_mysql zip \
    #Clean up apt caches to keep the image size small
    && apt-get clean && rm -rf /var/lib/apt/lists/* 

# Enable Apache mod_rewrite
RUN a2enmod rewrite \
    && sed -i 's|DocumentRoot /var/www/html|DocumentRoot /var/www/html/public|g' /etc/apache2/sites-enabled/000-default.conf \
    && sed -i 's|<Directory /var/www/html>|<Directory /var/www/html/public>|g' /etc/apache2/apache2.conf

RUN echo "<Directory /var/www/html/public>\n\
    AllowOverride All\n\
    Require all granted\n\
</Directory>" >> /etc/apache2/apache2.conf

# Install Composer using an official Composer image with Composer preinstalled
COPY --from=composer:latest /usr/bin/composer /usr/bin/composer

# Copy Laravel project files
COPY . /var/www/html

# Install Composer dependencies, excludes dev dependencies and optimized for production
RUN composer install --optimize-autoloader

# Set permissions for storage and bootstrap/cache directories
RUN chown -R www-data:www-data /var/www/html/storage /var/www/html/bootstrap/cache \
    && chmod -R 775 /var/www/html/storage /var/www/html/bootstrap/cache

# Copy the entrypoint script into the image path where all the globally executed scripts are located
COPY deploy.sh /usr/local/bin/deploy.sh

# Make the entrypoint script executable
RUN chmod +x /usr/local/bin/deploy.sh

# Expose port 80
EXPOSE 80

# Use custom entrypoint
ENTRYPOINT ["deploy.sh"]
