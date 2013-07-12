Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'apt-get update':
  command => 'apt-get update',
  timeout => 60,
  tries   => 3
}

class { 'apt':
  always_apt_update => true,
}

package { ['python-software-properties']:
  ensure  => 'installed',
  require => Exec['apt-get update'],
}

$sysPackages = [ 'build-essential', 'git', 'curl', 'vim']
package { $sysPackages:
  ensure => "installed",
  require => Exec['apt-get update'],
}
class { "apache": }

apache::module { 'rewrite': }

apache::vhost { 'default':
  docroot             => '/vagrant/web',
  server_name         => false,
  priority            => '',
  template            => 'vagrantee/apache/vhost.conf.erb',
}

apt::ppa { 'ppa:ondrej/php5':
  before  => Class['php'],
}

class { 'php': }

$phpModules = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']

php::module { $phpModules: }

php::ini { 'php':
  value   => ['date.timezone = "UTC"','upload_max_filesize = 8M', 'short_open_tag = 0'],
  target  => 'php.ini',
  service => 'apache',
}

class { 'mysql':
  root_password => 'root',
  require       => Exec['apt-get update'],
}

mysql::grant { 'default_db':
  mysql_privileges     => 'ALL',
  mysql_db             => 'default_db',
  mysql_user           => 'default',
  mysql_password       => '123456',
  mysql_host           => 'localhost',
  mysql_grant_filepath => '/home/vagrant/puppet-mysql',
}

class { 'phpmyadmin':
  require => Class['mysql'],
}

apache::vhost { 'phpmyadmin':
  server_name => false,
  docroot     => '/usr/share/phpmyadmin',
  port        => 8000,
  priority    => '10',
  require     => Class['phpmyadmin'],
  template    => 'vagrantee/apache/vhost.conf.erb',
}