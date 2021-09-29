#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

VARIABLES=$(realpath "${SCRIPT_DIR}/docker/acr.env")
#shellcheck source=docker/acr.env
source "${VARIABLES}"

az acr login -n "${REGISTRY_NAME}" --subscription "${SUBSCRIPTION_NAME}"

if [ ! -f .git/hooks/pre-commit ]; then
    cp example.git-pre-commit .git/hooks/pre-commit
fi

if [ ! -f .git/hooks/commit-msg ]; then
    cp example.git-commit-msg .git/hooks/commit-msg
fi

COMPOSE_FILES="-f docker-compose.yml"

if [[ -f "docker-compose.local.yml" ]]; then
  COMPOSE_FILES="${COMPOSE_FILES} -f docker-compose.local.yml"
fi

echo "Using compose files: ${COMPOSE_FILES}"

docker-compose ${COMPOSE_FILES} up -d --force-recreate || exit 1
docker-compose ${COMPOSE_FILES} ps || exit 1
docker-compose ${COMPOSE_FILES} exec php bash || exit 1
