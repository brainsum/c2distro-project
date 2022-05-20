<?php

namespace Drupal\Tests\c2dtests\ExistingSiteJavascript;

use weitzman\DrupalTestTraits\ExistingSiteWebDriverTestBase;

/**
 * Test for C2Distro related features.
 */
class C2dBasicTest extends ExistingSiteWebDriverTestBase {

  /**
   * Tests Frontpage.
   */
  public function testFrontpage() {
    $this->drupalGet('<front>');
    $this->assertSession()->pageTextContains('C2DISTRO');
    $this->assertSession()->pageTextContains('Home page');
    $this->assertSession()->pageTextContains('About Branches');
  }

}
