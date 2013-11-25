define zurmo::database::mysql(
  $ensure = 'present',
  $host = 'localhost',
  $password_hash = mysql_password('zurmo'),
  $user = 'zurmo',
) {
  include zurmo::database::mysql_server

  mysql_database { $name:
    collate => 'utf8_unicode_ci',
    ensure => $ensure,
  }

  mysql_user { "${user}@${host}":
    ensure => $ensure,
    password_hash => $password_hash,
  }

  mysql_grant { "${user}@${host}/${name}.*":
    ensure => $ensure,
    options => ['GRANT'],
    privileges => ['ALL'],
    table => "${name}.*",
    user => "${user}@${host}",
  }
}
