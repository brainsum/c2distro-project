#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

ACR=$(realpath "${SCRIPT_DIR}/../acr.env")
# shellcheck source=../variables.env
source "${ACR}"

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"


BUILD_TAG="${CONTAINER_REGISTRY}${PHP_IMAGE}:${PHP_IMAGE_TAG}"
LATEST_TAG="${CONTAINER_REGISTRY}${PHP_IMAGE}:latest"

echo "Pushing image: ${BUILD_TAG} / ${LATEST_TAG}"
docker push "${BUILD_TAG}"
docker push "${LATEST_TAG}"
