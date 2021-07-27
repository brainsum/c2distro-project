<?php

/**
 * @file
 * This file is built into the docker images as settings.local.php.
 */

$settings['container_yamls'][] = __DIR__ . '/services.monolog.yml';
$settings['container_yamls'][] = __DIR__ . '/services.local.yml';

if (file_exists(__DIR__ . '/settings.cache.php')) {
  include_once __DIR__ . '/settings.cache.php';
}

if (file_exists(__DIR__ . '/settings.proxy.php')) {
  include_once __DIR__ . '/settings.proxy.php';
}

if (file_exists(__DIR__ . '/settings.solr.php')) {
  include_once __DIR__ . '/settings.solr.php';
}

if (file_exists(__DIR__ . '/settings.elastic.php')) {
  include_once __DIR__ . '/settings.elastic.php';
}

if (file_exists(__DIR__ . '/settings.trusted-hosts.php')) {
  include_once __DIR__ . '/settings.trusted-hosts.php';
}

if (file_exists(__DIR__ . '/settings.email.php')) {
  include_once __DIR__ . '/settings.email.php';
}

// @todo: https://www.drupal.org/project/drupal/issues/3059139
// @todo: Add env vars to the containers: project, environment, ... [todo for helm chart].
// @todo: Add? Use some deployment-specific info, too, like commit hash?
// $settings['deployment_identifier'] = getenv('META_PROJECT') . '_' . getenv('META_ENVIRONMENT') . '_' . \Drupal::VERSION;
// @todo: Use `drush twigc` after `drush deploy`.
