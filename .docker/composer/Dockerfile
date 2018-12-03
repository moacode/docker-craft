FROM composer:1.7

# Installs a parallel processing plugin to improve composer performance,
# then we run composer install. We can probably remove this into a build container in the future.
RUN composer global require hirak/prestissimo

CMD ["composer"]