<?php
// Copy this file to config.php and fill in the password.
// config.php is listed in .gitignore, so it never reaches GitHub.
return [
  'db_host' => 'localhost',
  'db_name' => 'aquamari_dashboard',
  'db_user' => 'aquamari_admin',
  'db_pass' => '',

  // Where a new lead is announced. Leave blank for no email.
  'notify'  => '',

  // The public site, used in links back out of the dashboard.
  'site'    => 'https://aquamarine-ws.com',

  // install.php answers only to this key, so nobody can reach the
  // setup page in the minutes before the first administrator exists.
  // Put a long random string here; after setup, delete install.php.
  'install_key' => '',
];
