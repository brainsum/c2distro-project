# @todo: Add neat features from wodby images, e.g hostanme override.
# @todo: Add xdebug.
# @todo: Maybe fully separate prod and dev fully (dev doesn't really need the src code).
# @todo: Maybe add a CLI image (prod + mysql, drush, ..).
ARG BUILDER_IMAGE
ARG BUILDER_IMAGE_TAG
ARG BASE_IMAGE
ARG BASE_IMAGE_TAG


FROM $BUILDER_IMAGE:$BUILDER_IMAGE_TAG as builder

# Utilize the build cache:
# - Assumption: Dependencies are less likely to change than the rest of the codebase.
# - Solution: Build dependencies first then copy over the rest of the codebase in a later layer.
COPY --chown=${USER_NAME} drush/local/example.drush.yml drush/local/drush.yml
COPY --chown=${USER_NAME} patches/ patches/
COPY --chown=${USER_NAME} scripts/ scripts/
COPY --chown=${USER_NAME} composer.json composer.lock ./

RUN composer install -o --no-dev --no-suggest

COPY --chown=${USER_NAME} . .

# Ensure that main config files are read-only.
# Add K8s settings as local settings.
RUN \
    mv "${APP_ROOT}/settings/settings.kubernetes.php" "${APP_ROOT}/settings/settings.local.php" \
    && chmod ugo-w web/sites/default/settings.php \
    && chmod ugo-w web/sites/default/services.yml

WORKDIR "${APP_ROOT}/web/themes/custom/c2_theme/"

RUN \
  npm ci \
  && npm run build \
  && rm -rf node_modules patternlab

WORKDIR ${APP_ROOT}

# ------
# Multistage build reduces the image size by a lot.
FROM $BASE_IMAGE:$BASE_IMAGE_TAG as prod

ENV \
    PATH="/usr/local/bin:${APP_ROOT}/vendor/bin:${PATH}" \
    PHP_MEMORY_LIMIT="1024M" \
    PHP_ERROR_REPORTING="E_ALL & ~E_DEPRECATED & ~E_STRICT" \
    PHP_DISPLAY_ERRORS="Off" \
    PHP_DISPLAY_STARTUP_ERRORS="Off" \
    PHP_MYSQLND_COLLECT_MEMORY_STATISTICS="Off" \
    PHP_ZEND_ASSERTIONS="-1" \
    PHP_OPCACHE_HUGE_CODE_PAGES="1" \
    PHP_OPCACHE_VALIDATE_TIMESTAMPS="0" \
    PHP_OPCACHE_REVALIDATE_FREQ="0" \
    PHP_SENDMAIL_PATH="sendmail -t -i" \
    FPM_LOG_LEVEL="notice" \
    FPM_PM_MAX_CHILDREN="50" \
    FPM_PM_START_SERVERS="8" \
    FPM_PM_MIN_SPARE_SERVERS="3" \
    FPM_PM_MAX_SPARE_SERVERS="35"

USER ${USER_NAME}

COPY --from=builder --chown=${USER_NAME} "${APP_ROOT}" "${APP_ROOT}"
