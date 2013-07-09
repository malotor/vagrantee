class vagrantee(
  $sysPackages = [ "build-essential" ],
  $docroot = "/var/www"
) {

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  package { $sysPackages:
    ensure => "installed",
    require => Exec['apt-get update'],
  }

  apache::vhost { 'default':
    docroot             => $docroot,
    server_name         => false,
    priority            => ''
  }

  class { 'php':
    version => '5.4.15'
  }

}