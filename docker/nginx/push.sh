#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

ACR=$(realpath "${SCRIPT_DIR}/../acr.env")
# shellcheck source=../variables.env
source "${ACR}"

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

REPOSITORY="${CONTAINER_REGISTRY}${NGINX_IMAGE}"
BUILD_TAG="${REPOSITORY}:${NGINX_IMAGE_TAG}"
LATEST_TAG="${REPOSITORY}:latest"

echo "Pushing image: ${BUILD_TAG}-base / ${LATEST_TAG}-base"
docker push "${BUILD_TAG}-base"
docker push "${LATEST_TAG}-base"

if [[ "$1" == "--skip-prod" ]] || [[ "$2" == "--skip-prod" ]];
then
  echo "Skipping prod image push for nginx."
  exit 0
fi

echo "Pushing image: ${BUILD_TAG} / ${LATEST_TAG}"
docker push "${BUILD_TAG}"
docker push "${LATEST_TAG}"
