#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

ACR=$(realpath "${SCRIPT_DIR}/../acr.env")
# shellcheck source=../variables.env
source "${ACR}"

VARIABLES=$(realpath "${SCRIPT_DIR}/../variables.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

BUILD_TAG="${CONTAINER_REGISTRY}${APP_IMAGE}:${APP_IMAGE_TAG}"
LATEST_TAG="${CONTAINER_REGISTRY}${APP_IMAGE}:latest"

echo "Pushing image: ${BUILD_TAG} / ${LATEST_TAG}"

if [[ "$1" == "--skip-prod" ]] || [[ "$2" == "--skip-prod" ]];
then
  echo "Skipping prod image push for drupal."
  exit 0
fi

docker push "${BUILD_TAG}"
docker push "${LATEST_TAG}"
