# Base image
FROM php:8.1-apache

# Install necessary dependencies
RUN apt-get update && apt-get install -y \
    libpng-dev \
    libjpeg-dev \
    libfreetype6-dev \
    libonig-dev \
    libzip-dev \
    unzip \
    git \
    curl \
    mariadb-client \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install pdo_mysql mysqli gd zip mbstring opcache

# Enable Apache modules
RUN a2enmod rewrite

# Set environment variables
ENV MOODLE_VERSION 4.2.1
ENV MOODLE_URL https://github.com/moodle/moodle/archive/refs/tags/v$MOODLE_VERSION.zip
ENV MOODLE_DATA /var/moodledata
ENV MOODLE_DIR /var/www/html

# Download and extract Moodle
RUN curl -o moodle.zip -L $MOODLE_URL && \
    unzip moodle.zip -d /var/www/html && \
    mv /var/www/html/moodle-$MOODLE_VERSION/* /var/www/html/ && \
    rm -rf /var/www/html/moodle-$MOODLE_VERSION moodle.zip

# Set permissions
RUN mkdir -p $MOODLE_DATA && \
    chown -R www-data:www-data $MOODLE_DATA $MOODLE_DIR && \
    chmod -R 755 $MOODLE_DIR

# Expose HTTP port
EXPOSE 80

# Start the server
CMD ["apache2-foreground"]