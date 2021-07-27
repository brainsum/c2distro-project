ARG BASE_IMAGE
ARG BASE_IMAGE_TAG
ARG SOURCE_CODE_IMAGE
ARG SOURCE_CODE_IMAGE_TAG


FROM ${BASE_IMAGE}:${BASE_IMAGE_TAG} as base

ENV \
    APP_ROOT="/var/www/html"

USER root

RUN \
    touch /usr/share/nginx/logs/error.log \
    && chown nginx:nginx /usr/share/nginx/logs/error.log \
    && chmod u+x /usr/share/nginx/logs/error.log

USER nginx

COPY config/ /etc/nginx/

ENTRYPOINT []
CMD ["nginx"]


# Args don't seem to be supported in `COPY --from` so add the source code image as a build stage.
FROM ${SOURCE_CODE_IMAGE}:${SOURCE_CODE_IMAGE_TAG} as source


FROM base as prod

COPY --from=source /var/www/html /var/www/html/
