#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

ACR=$(realpath "${SCRIPT_DIR}/../acr.env")
# shellcheck source=../variables.env
source "${ACR}"

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"


REPOSITORY="${CONTAINER_REGISTRY}${PHP_BUILDER_IMAGE}"
BUILD_TAG="${REPOSITORY}:${PHP_BUILDER_IMAGE_TAG}"
LATEST_TAG="${REPOSITORY}:latest"

echo "Pushing image: ${BUILD_TAG} / ${LATEST_TAG}"

docker push "${BUILD_TAG}"
docker push "${LATEST_TAG}"



REPOSITORY="${CONTAINER_REGISTRY}${NODE_IMAGE}"
BUILD_TAG="${REPOSITORY}:${NODE_IMAGE_TAG}"
LATEST_TAG="${REPOSITORY}:latest"

docker push "${BUILD_TAG}"
docker push "${LATEST_TAG}"

echo "Pushing image: ${BUILD_TAG} / ${LATEST_TAG}"
