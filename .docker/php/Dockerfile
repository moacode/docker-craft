FROM php:7.2-fpm-alpine3.8

ARG UID
ARG GID

USER root

COPY ./.docker/php/custom.ini /usr/local/etc/php/conf.d/custom.ini

# Installs required libraries for the PHP environment.
# As the Alpine Distro is barebones, we need to install compiling tools first. These are removed at the end to keep the build size down.
# We require imagemagick and imagemagick-dev, otherwise the delegates for jpeg and png cannot be found.
# https://github.com/docker-library/php/issues/105#issuecomment-278114879
RUN apk add --update --no-cache \
  autoconf \
  g++\
  icu-dev\
  make\
  pcre-dev \
  composer\
  php7-intl\
  libtool\
  libzip-dev\
  zip \
  libpng\
  libjpeg-turbo\
  imagemagick\
  imagemagick-dev \
  && export CFLAGS="$PHP_CFLAGS" CPPFLAGS="$PHP_CPPFLAGS" LDFLAGS="$PHP_LDFLAGS" \
  && docker-php-ext-configure intl \
  && docker-php-ext-configure zip --with-libzip \
  && docker-php-ext-install bcmath mysqli pdo_mysql intl zip \
	&& pecl install imagick \
	&& docker-php-ext-enable imagick \
	&& apk del autoconf g++ icu-dev libtool make pcre-dev

# Creates a new user `plato` and group `staff`, which matches the UID and GID of the host environment.
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

# Installs a parallel processing plugin to improve composer performance,
# then we run composer install. We can probably remove this into a build container in the future.
RUN composer global require hirak/prestissimo
RUN composer install -d /var/www/html/

WORKDIR /var/www/html/