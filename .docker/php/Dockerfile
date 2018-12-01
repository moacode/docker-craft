FROM php:7.2-fpm-alpine3.8

ARG UID
ARG GID

USER root

COPY ./.docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# imagemagick, mysqli, pdo_mysql & zip
RUN apk add --update --no-cache autoconf composer g++ imagemagick-dev icu-dev php7-intl libtool libzip-dev make pcre-dev zip \
	&& docker-php-ext-install mysqli pdo_mysql \
	&& docker-php-ext-configure intl && docker-php-ext-install intl \
	&& docker-php-ext-configure zip --with-libzip && docker-php-ext-install zip \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& apk del autoconf g++ icu-dev libtool make pcre-dev

RUN apk add --no-cache shadow sudo && \
    if [ -z "`getent group $GID`" ]; then \
      addgroup -S -g $GID staff; \
    else \
      groupmod -n staff `getent group $GID | cut -d: -f1`; \
    fi && \
    if [ -z "`getent passwd $UID`" ]; then \
      adduser -S -u $UID -G staff -s /bin/sh plato; \
    else \
      usermod -l plato -g $GID -d /home/plato -m `getent passwd $UID | cut -d: -f1`; \
    fi && \
    echo "plato ALL=(root) NOPASSWD:ALL" > /etc/sudoers.d/plato && \
    chmod 0440 /etc/sudoers.d/plato

RUN chown plato:staff /var/www/html/

USER plato

# Copy composer.json file, required for composer install
# COPY ./container/config /var/www/html/config
# COPY ./container/modules /var/www/html/modules
# COPY ./container/templates /var/www/html/templates
# COPY ./container/web /var/www/html/web
COPY ./container/composer.json /var/www/html/composer.json
COPY ./container/craft /var/www/html/craft

RUN mkdir -p /var/www/html/storage/rebrand && \
    mkdir -p /var/www/html/storage/runtime/mutex && \
    mkdir -p /var/www/html/storage/logs

RUN composer install -d /var/www/html/

WORKDIR /var/www/html/