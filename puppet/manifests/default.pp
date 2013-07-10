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

$sysPackages = [ 'build-essential', 'git', 'curl']
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
  template            => 'apache/virtualhost/vhost.conf.erb',
}

apt::ppa { 'ppa:ondrej/php5':
  before  => Class['php'],
}

class { 'php': }

$phpModules = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache']

php::module { $phpModules: }

php::ini { 'php':
  value   => ['date.timezone = "Europe/Amsterdam"'],
  target  => 'php.ini',
  service => 'apache',
}
