#!/usr/bin/env bash

SCRIPT=$(readlink -f "$0")
SCRIPT_DIR=$(dirname "$SCRIPT")


echo "Linting php"
docker run --rm -i hadolint/hadolint < "${SCRIPT_DIR}/php/Dockerfile"
echo ""

echo "Linting drupal"
docker run --rm -i hadolint/hadolint < "${SCRIPT_DIR}/drupal/Dockerfile"
echo ""

echo "Linting nginx"
docker run --rm -i hadolint/hadolint < "${SCRIPT_DIR}/nginx/Dockerfile"
echo ""
