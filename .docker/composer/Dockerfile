FROM composer:1.7

ARG UID
ARG GID

USER root

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

RUN chown plato:staff /app

USER plato

WORKDIR /app

RUN mkdir -p vendor

# Installs a parallel processing plugin to improve composer performance,
# then we run composer install. We can probably remove this into a build container in the future.
RUN composer global require hirak/prestissimo

CMD ["composer"]