# @todo: Add neat features from wodby images, e.g hostanme override.
# @todo: Add xdebug.
# @todo: Maybe fully separate prod and dev fully (dev doesn't really need the src code).
# @todo: Maybe add a CLI image (prod + mysql, drush, ..).

ARG BASE_IMAGE
ARG BASE_IMAGE_TAG

FROM $BASE_IMAGE:$BASE_IMAGE_TAG as php-base

ARG NODE_VERSION
ARG COMPOSER_VERSION

ENV \
    PATH="/usr/local/bin:${APP_ROOT}/vendor/bin:${PATH}" \
    COMPOSER_VERSION=${COMPOSER_VERSION} \
    MHSENDMAIL_VERSION="v0.2.0" \
    PHP_MEMORY_LIMIT="2048M" \
    PHP_ERROR_REPORTING="E_ALL" \
    PHP_DISPLAY_ERRORS="On" \
    PHP_DISPLAY_STARTUP_ERRORS="On" \
    PHP_MYSQLND_COLLECT_MEMORY_STATISTICS="On" \
    PHP_ZEND_ASSERTIONS="1" \
    PHP_OPCACHE_HUGE_CODE_PAGES="0" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="1" \
    PHP_OPCACHE_REVALIDATE_FREQ="1" \
    PHP_SENDMAIL_PATH="/usr/local/bin/mhsendmail --smtp-addr=mailhog:1025" \
    FPM_LOG_LEVEL="debug" \
    FPM_PM_MAX_CHILDREN="10" \
    FPM_PM_START_SERVERS="2" \
    FPM_PM_MIN_SPARE_SERVERS="1" \
    FPM_PM_MAX_SPARE_SERVERS="8"

# @todo: Add:
# \ curl https://composer.github.io/snapshots.pub -L -o ~/.composer/keys.dev.pub
# \ curl https://composer.github.io/releases.pub -L -o ~/.composer/keys.tags.pub
# @todo: sha384 check | https://composer.github.io/installer.sha384sum or "756890a4488ce9024fc62c56153228907f1545c228516cbf63f885e036d37e9a59d27d63f46af1d4d07ee0f76181c7d3"

RUN \
    apt-get update \
    && apt-get install -y --no-install-recommends \
        git \
        gosu \
        unzip \
    && rm -rf /var/lib/apt/lists/* \
    && curl "https://getcomposer.org/download/${COMPOSER_VERSION}/composer.phar" \
         -L \
         -o /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer \
    && chown "${USER_NAME}:${USER_NAME}" /usr/local/bin/ /usr/local/bin/composer \
    && curl "https://github.com/mailhog/mhsendmail/releases/download/${MHSENDMAIL_VERSION}/mhsendmail_linux_amd64" \
        -L \
        -o /usr/local/bin/mhsendmail \
    && chmod +x /usr/local/bin/mhsendmail

# Note: ${APP_ROOT} is /var/www/html
# Note: ${USER_NAME} is php

FROM php-base as php-node-base

# We need both php and node for this.
# @see: https://github.com/nodejs/docker-node/tree/master/14/buster-slim
USER root

COPY bin/docker-node-entrypoint.sh /usr/local/bin/

ENV \
   NODE_VERSION=$NODE_VERSION \
   NODE_ENV="development"

# @todo: Critical: Re-add these after upgrade to v14:
#    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/SHASUMS256.txt.asc" \
#    && gpg --batch --decrypt --output SHASUMS256.txt SHASUMS256.txt.asc \
#    && grep " node-v$NODE_VERSION-linux-$ARCH.tar.xz\$" SHASUMS256.txt | sha256sum -c - \
#    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" SHASUMS256.txt.asc SHASUMS256.txt \
RUN ARCH= && dpkgArch="$(dpkg --print-architecture)" \
    && case "${dpkgArch##*-}" in \
      amd64) ARCH='x64';; \
      ppc64el) ARCH='ppc64le';; \
      s390x) ARCH='s390x';; \
      arm64) ARCH='arm64';; \
      armhf) ARCH='armv7l';; \
      i386) ARCH='x86';; \
      *) echo "unsupported architecture"; exit 1 ;; \
    esac \
    && set -ex \
    && savedAptMark="$(apt-mark showmanual)" \
    # libatomic1 for arm
    && apt-get update && apt-get install -y ca-certificates curl wget gnupg dirmngr xz-utils libatomic1 --no-install-recommends \
    && rm -rf /var/lib/apt/lists/* \
    && for key in \
      4ED778F539E3634C779C87C6D7062848A1AB005C \
      94AE36675C464D64BAFA68DD7434390BDBE9B9C5 \
      1C050899334244A8AF75E53792EF661D867B9DFA \
      71DCFD284A79C3B38668286BC97EC7A07EDE3FC1 \
      8FCCA13FEF1D0C2E91008E09770F7A9A5AE15600 \
      C4F0DFFF4E8C1A8236409D08E73BC641CC11F4C8 \
      C82FA3AE1CBEDC6BE46B9360C43CEC45C17AB93C \
      DD8F2338BAE7501E3DD5AC78C273792F7D83545D \
      A48C2BEE680E841632CD4E44F07496B3EB3C1762 \
      108F52B48DB57BB0CC439B2997B01419BD92F80A \
      B9E2F5981AA6E0CD28160D9FF13993A75599653C \
    ; do \
      gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$key" || \
      gpg --batch --keyserver keyserver.ubuntu.com --recv-keys "$key"; \
    done \
    && curl -fsSLO --compressed "https://nodejs.org/dist/v$NODE_VERSION/node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && tar -xJf "node-v$NODE_VERSION-linux-$ARCH.tar.xz" -C /usr/local --strip-components=1 --no-same-owner \
    && rm "node-v$NODE_VERSION-linux-$ARCH.tar.xz" \
    && apt-mark auto '.*' > /dev/null \
    && apt-mark manual ${savedAptMark} \
    && find /usr/local -type f -executable -exec ldd '{}' ';' \
      | awk '/=>/ { print $(NF-1) }' \
      | sort -u \
      | xargs -r dpkg-query --search \
      | cut -d: -f1 \
      | sort -u \
      | xargs -r apt-mark manual \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && ln -s /usr/local/bin/node /usr/local/bin/nodejs \
    # smoke tests
    && node --version \
    && npm --version

# Whatever is needed for npm.
RUN set -eux \
    && apt-get update \
    && apt-get install -y --no-install-recommends \
      python \
      build-essential \
    && savedAptMark="$(apt-mark showmanual)" \
    && apt-mark manual ${savedAptMark} \
    && apt-get purge -y --auto-remove -o APT::AutoRemove::RecommendsImportant=false \
    && rm -rf /var/lib/apt/lists/*

USER php


FROM php-node-base as node

ENTRYPOINT ["docker-node-entrypoint.sh"]
CMD [ "node" ]
WORKDIR "${APP_ROOT}/web/themes/custom/c2_theme/"
