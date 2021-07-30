#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

VARIABLES=$(realpath "${SCRIPT_DIR}/docker/acr.env")
# shellcheck source=docker/acr.env
source "${VARIABLES}"

az acr login -n "${REGISTRY_NAME}" --subscription "${SUBSCRIPTION_NAME}"

COMPOSE_FILES="-f docker-compose.yml"

if [[ -f "docker-compose.local.yml" ]]; then
  COMPOSE_FILES="${COMPOSE_FILES} -f docker-compose.local.yml"
fi

echo "Using compose files: ${COMPOSE_FILES}"

docker-compose ${COMPOSE_FILES} up -d --force-recreate || exit 1
docker-compose ${COMPOSE_FILES} ps || exit 1
docker-compose ${COMPOSE_FILES} exec php sh || exit 1
