ARG BASE_IMAGE
ARG BASE_IMAGE_TAG

FROM $BASE_IMAGE:$BASE_IMAGE_TAG

SHELL ["/bin/bash", "-o", "pipefail", "-c"]

ENV \
    USER_NAME="php" \
    WEB_USER_NAME="www-data" \
    APP_ROOT="/var/www/html"

WORKDIR ${APP_ROOT}

RUN groupadd --gid 1000 "${USER_NAME}" \
  && useradd --uid 1000 --gid "${USER_NAME}" --shell /bin/bash --create-home "${USER_NAME}" \
  && usermod -aG "${WEB_USER_NAME}" "${USER_NAME}" \
  && chown "${WEB_USER_NAME}:${WEB_USER_NAME}" "/var/www/"

# @todo: Move default-mysql-client to dev and cli images only (only needed for drush).
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
        default-mysql-client \
        libfcgi-bin \
        sendmail \
        imagemagick \
        libmagickcore-6.q16-6-extra \
        ghostscript \
    && savedAptMark="$(apt-mark showmanual)" \
    && apt-get install -y --no-install-recommends \
        libfreetype6-dev \
        libjpeg-dev \
        libpng-dev \
        libpq-dev \
        libzip-dev \
        libmagickwand-dev \
    && docker-php-source extract \
    && pecl install \
        uploadprogress-1.1.3 \
        apcu-5.1.20 \
        igbinary-3.2.2 \
        imagick-3.4.4 \
    && pecl bundle -d /usr/src/php/ext \
        redis-5.3.4 \
    && docker-php-ext-configure gd \
        --with-freetype \
        --with-jpeg \
    && docker-php-ext-configure redis \
        --enable-redis-igbinary \
    && docker-php-ext-install -j "$(nproc)" \
        gd \
        opcache \
        pdo_mysql \
        zip \
        exif \
        gettext \
        mysqli \
        redis \
    && docker-php-ext-enable \
        uploadprogress \
        igbinary \
        apcu \
        imagick \
    && docker-php-source delete \
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual ${savedAptMark} \
    && ldd "$(php -r 'echo ini_get("extension_dir");')"/*.so \
        | awk '/=>/ { print $3 }' \
        | sort -u \
        | xargs -r dpkg-query -S \
        | cut -d: -f1 \
        | sort -u \
        | xargs -rt apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /tmp/*

COPY --chmod=0555 fpm/php-fpm-healthcheck /usr/local/bin/php-fpm-healthcheck
COPY config/ /usr/local/etc/php/
COPY fpm/zzz-fpm.conf /usr/local/etc/php-fpm.d/zzz-fpm.conf
COPY imagemagick/policy.xml /etc/ImageMagick-6/policy.xml
