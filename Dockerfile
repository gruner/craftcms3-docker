FROM php:7.2-apache
MAINTAINER Andrew Gruner "andrew.gruner@gmail.com"

ENV APP_DIR /var/www/craftcms3

# Enable additional apache modules
RUN a2enmod expires && a2enmod headers && a2enmod ssl && a2enmod rewrite

# PHP libraries
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y \
        git \
        libpq-dev \
        zlib1g-dev \
        libmemcached-dev \
        libicu-dev \
        g++ \
    && docker-php-ext-configure pgsql -with-pgsql=/usr/local/pgsql \
    && docker-php-ext-install -j$(nproc) intl pdo_mysql pdo_pgsql pgsql opcache zip \
    && pecl install memcached \
    && docker-php-ext-enable memcached

# ImageMagick
RUN apt-get update \
    && apt-get install --no-install-recommends --no-install-suggests -q -y libmagickwand-6.q16-dev \
    && ln -s /usr/lib/x86_64-linux-gnu/ImageMagick-6.8.9/bin-Q16/MagickWand-config /usr/bin \
    && pecl install imagick \
    && docker-php-ext-enable imagick

# Configs
COPY php.ini ${PHP_INI_DIR}
COPY craftcms3-http.conf $APACHE_CONFDIR/sites-enabled/000-default.conf

# Composer

ENV COMPOSER_VERSION 1.6.3

RUN curl -o /tmp/composer-setup.php https://getcomposer.org/installer \
    && curl -o /tmp/composer-setup.sig https://composer.github.io/installer.sig \
    && php -r "if (hash('SHA384', file_get_contents('/tmp/composer-setup.php')) !== trim(file_get_contents('/tmp/composer-setup.sig'))) { unlink('/tmp/composer-setup.php'); echo 'Invalid installer' . PHP_EOL; exit(1); }"

RUN php /tmp/composer-setup.php --no-ansi --install-dir=/usr/local/bin --filename=composer --version=${COMPOSER_VERSION} && rm -rf /tmp/composer-setup.php

# Create Craft project

RUN composer create-project craftcms/craft ${APP_DIR}

RUN composer require craftcms/element-api \
  && composer require craftcms/aws-s3

# Add PHP dotenv environment variables file
COPY .env.example ${APP_DIR}/.env

# Add default craft config
COPY ./config ${APP_DIR}/config

RUN chown -R www-data:www-data ${APP_DIR} \
    && chmod -R 775 ${APP_DIR}