Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

exec { 'apt-get update':
  command => 'apt-get update',
}

$sysPackages = [ 'build-essential', 'git', 'curl']
package { $sysPackages:
  ensure => "installed",
  require => Exec['apt-get update'],
}
class { "apache": }

apache::vhost { 'default':
  docroot             => '/vagrant/web',
  server_name         => false,
  priority            => '',
  template            => 'apache/virtualhost/vhost.conf.erb',
}

class { 'php': }

$phpPackages = [ 'imagick', 'curl']

php::module { $phpPackages: }