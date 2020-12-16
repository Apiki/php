FROM php:5.6.40-fpm-alpine3.8
MAINTAINER mesaque.s.silva@gmail.com

RUN apk update && \
    apk upgrade && \
    apk add --no-cache freetype libpng libjpeg-turbo freetype-dev libpng-dev libjpeg-turbo-dev libxml2-dev curl-dev  libmcrypt-dev libpq cyrus-sasl-dev libzip libzip-dev libmemcached-dev msmtp pcre-dev zlib-dev git zip bash vim sudo bind-tools libsodium-dev libssh2-dev imagemagick-dev libmcrypt-dev && \
  docker-php-ext-configure gd --with-freetype --with-jpeg && \
  NPROC=$(grep -c ^processor /proc/cpuinfo 2>/dev/null || 1) && \
  docker-php-ext-install -j${NPROC} gd && \
  apk del --no-cache freetype-dev libpng-dev libjpeg-turbo-dev

RUN cd /usr/bin && curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && mv /usr/bin/wp-cli.phar /usr/bin/wp && chmod +x /usr/bin/wp

RUN docker-php-ext-install zip mysqli mysql sockets soap calendar bcmath opcache exif iconv ftp

RUN deluser www-data && deluser xfs
RUN echo "www-data:x:33:33:Apiki WP Host,,,:/var/www:/bin/false" >> /etc/passwd && echo "www-data:x:33:www-data" >> /etc/group
WORKDIR /var/www
USER www-data
