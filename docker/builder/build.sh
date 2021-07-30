#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

ACR=$(realpath "${SCRIPT_DIR}/../acr.env")
# shellcheck source=../variables.env
source "${ACR}"

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

if [[ "$1" == "--without-registry" ]] || [[ "$2" == "--without-registry" ]];
then
  echo "Disabling registry."
  CONTAINER_REGISTRY=""
fi

CONTEXT=$(realpath "${SCRIPT_DIR}")

REPOSITORY="${CONTAINER_REGISTRY}${PHP_BUILDER_IMAGE}"
BUILD_TAG="${REPOSITORY}:${PHP_BUILDER_IMAGE_TAG}"
LATEST_TAG="${REPOSITORY}:latest"

echo "Context: ${CONTEXT}"
echo "Building image: ${BUILD_TAG} / ${LATEST_TAG}"

DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}" \
    -t "${LATEST_TAG}" \
    --target "php-node-base" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${CONTAINER_REGISTRY}${PHP_BUILDER_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${PHP_BUILDER_BASE_IMAGE_TAG}" \
    --build-arg NODE_VERSION="${NODE_VERSION}" \
    --build-arg COMPOSER_VERSION="${COMPOSER_VERSION}" \
    --label NODE_VERSION="${NODE_VERSION}" \
    --label COMPOSER_VERSION="${COMPOSER_VERSION}" \
    "${CONTEXT}" || exit 1

REPOSITORY="${CONTAINER_REGISTRY}${NODE_IMAGE}"
BUILD_TAG="${REPOSITORY}:${NODE_IMAGE_TAG}"
LATEST_TAG="${REPOSITORY}:latest"

echo "Context: ${CONTEXT}"
echo "Building image: ${BUILD_TAG} / ${LATEST_TAG}"

DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}" \
    -t "${LATEST_TAG}" \
    --target "node" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${CONTAINER_REGISTRY}${PHP_BUILDER_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${PHP_BUILDER_BASE_IMAGE_TAG}" \
    --build-arg NODE_VERSION="${NODE_VERSION}" \
    --build-arg COMPOSER_VERSION="${COMPOSER_VERSION}" \
    --label NODE_VERSION="${NODE_VERSION}" \
    --label COMPOSER_VERSION="${COMPOSER_VERSION}" \
    "${CONTEXT}" || exit 1
