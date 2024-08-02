#!/bin/bash

composer install \
    && cd web \
    && ../vendor/bin/drush deploy \
    || exit -1

CIMTESTRET=$( { ../vendor/bin/drush cim -n; } 2>&1 )
if [[ ${CIMTESTRET} == *"There are no changes to import"* ]]; then
  echo "Config import successful.";
else
  echo "Config import was not completely successful.";
  exit -1;
fi
