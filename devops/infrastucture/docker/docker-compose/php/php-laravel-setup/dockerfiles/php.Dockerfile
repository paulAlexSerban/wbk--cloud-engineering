FROM php:8-fpm-alpine

# standard server on web server to serve your website from
WORKDIR /var/www/html

RUN docker-php-ext-install pdo pdo_mysql