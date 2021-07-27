#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")

echo "Logging in to the CR.."

VARIABLES=$(realpath "${SCRIPT_DIR}/acr.env")
# shellcheck source=../variables.env
source "${VARIABLES}"

az acr login -n "${REGISTRY_NAME}" --subscription "${SUBSCRIPTION_NAME}"

# @note: Push order is required as this.
bash "${SCRIPT_DIR}/php/push.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/builder/push.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/drupal/push.sh" "$@" || exit 1
bash "${SCRIPT_DIR}/nginx/push.sh" "$@" || exit 1


echo "Done."
