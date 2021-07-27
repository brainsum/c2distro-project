#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

if [[ "$1" == "--without-registry" ]] || [[ "$2" == "--without-registry" ]];
then
  echo "Disabling registry."
  CONTAINER_REGISTRY=""
fi

BUILD_TAG="${CONTAINER_REGISTRY}${NGINX_IMAGE}:${NGINX_IMAGE_TAG}"
LATEST_TAG="${CONTAINER_REGISTRY}${NGINX_IMAGE}:latest"
CONTEXT=$(realpath "${SCRIPT_DIR}")

echo "Context: ${CONTEXT}"
echo "Src code: ${CONTAINER_REGISTRY}${APP_IMAGE}:${APP_IMAGE_TAG}"

echo "Building nginx image: ${BUILD_TAG}-base"
DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}-base" \
    -t "${LATEST_TAG}-base" \
    --target base \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${CONTAINER_REGISTRY}${NGINX_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${NGINX_BASE_IMAGE_TAG}" \
    --build-arg SOURCE_CODE_IMAGE="${CONTAINER_REGISTRY}${APP_IMAGE}" \
    --build-arg SOURCE_CODE_IMAGE_TAG="${APP_IMAGE_TAG}" \
    "${CONTEXT}" || exit 1

if [[ "$1" == "--skip-prod" ]] || [[ "$2" == "--skip-prod" ]];
then
  echo "Skipping prod image build for nginx."
  exit 0
fi

echo "Building nginx image: ${BUILD_TAG}"
DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}" \
    -t "${LATEST_TAG}" \
    --target prod \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${CONTAINER_REGISTRY}${NGINX_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${NGINX_BASE_IMAGE_TAG}" \
    --build-arg SOURCE_CODE_IMAGE="${CONTAINER_REGISTRY}${APP_IMAGE}" \
    --build-arg SOURCE_CODE_IMAGE_TAG="${APP_IMAGE_TAG}" \
    "${CONTEXT}" || exit 1
