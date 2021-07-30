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

BUILD_TAG="${CONTAINER_REGISTRY}${PHP_IMAGE}:${PHP_IMAGE_TAG}"
LATEST_TAG="${CONTAINER_REGISTRY}${PHP_IMAGE}:latest"
CONTEXT=$(realpath "${SCRIPT_DIR}")

echo "Building php image: ${BUILD_TAG} and ${LATEST_TAG}"
echo "Context: ${CONTEXT}"

DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}" \
    -t "${LATEST_TAG}" \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${PHP_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${PHP_BASE_IMAGE_TAG}" \
    "${CONTEXT}" || exit 1
