#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

echo "Logging in to the CR.."

VARIABLES=$(realpath "${SCRIPT_DIR}/acr.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

az acr login -n "${REGISTRY_NAME}" --subscription "${SUBSCRIPTION_NAME}"

# @note: Build order is required as this.
bash "${SCRIPT_DIR}/php/build.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/builder/build.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/drupal/build.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/nginx/build.sh" "$@" || exit 1

# 100Gb of accumulated build cache is not really funny.
echo ""
echo "Using 'docker builder prune -f' for freeing up some space.."
docker builder prune -f

echo "Done."
