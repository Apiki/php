FROM php:7.4.4-fpm
MAINTAINER mesaque.silva@apiki.com

RUN apt-get update && apt-get install -y msmtp libzip-dev libxml2-dev libssl-dev imagemagick libmagickwand-dev libmagickcore-dev libmcrypt-dev libmemcached-dev

RUN apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

RUN echo '' | pecl install -f memcached
RUN echo '' | pecl install -f imagick
RUN echo '' | pecl install -f mcrypt
RUN echo '' | pecl install -f redis

RUN cd /usr/bin && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && mv /usr/bin/wp-cli.phar /usr/bin/wp && chmod +x /usr/bin/wp

RUN docker-php-ext-install zip mysqli sockets soap calendar bcmath opcache exif iconv ftp
RUN docker-php-ext-enable  redis imagick mcrypt memcached

WORKDIR /var/www
USER www-data