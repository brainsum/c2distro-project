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

if [[ "$1" == "--skip-prod" ]] || [[ "$2" == "--skip-prod" ]];
then
  echo "Skipping prod image build for drupal."
  exit 0
fi

BUILD_TAG="${CONTAINER_REGISTRY}${APP_IMAGE}:${APP_IMAGE_TAG}"
LATEST_TAG="${CONTAINER_REGISTRY}${APP_IMAGE}:latest"
CONTEXT=$(realpath "${SCRIPT_DIR}/../../app")

echo "Context: ${CONTEXT}"

echo "Building image: ${BUILD_TAG} / ${LATEST_TAG}"
DOCKER_BUILDKIT=1 docker build \
    --progress=plain \
    --rm \
    -f "${SCRIPT_DIR}/Dockerfile" \
    -t "${BUILD_TAG}" \
    -t "${LATEST_TAG}" \
    --target prod \
    --build-arg BUILDKIT_INLINE_CACHE=1 \
    --build-arg BASE_IMAGE="${CONTAINER_REGISTRY}${APP_BASE_IMAGE}" \
    --build-arg BASE_IMAGE_TAG="${APP_BASE_IMAGE_TAG}" \
    --build-arg BUILDER_IMAGE="${CONTAINER_REGISTRY}${APP_BUILDER_IMAGE}" \
    --build-arg BUILDER_IMAGE_TAG="${APP_BUILDER_IMAGE_TAG}" \
    "${CONTEXT}" || exit 1
