class vagrantee(
  $php_modules     = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache'],
  $sys_packages    = [ 'build-essential', 'git', 'curl', 'vim'],
  $mysql_host      = 'localhost',
  $mysql_db        = 'default',
  $mysql_user      = 'default',
  $mysql_pass      = 'password',
  $mysql_root_pass = 'root',
  $pma_pass        = 'root',
  $pma_port        = 8000
) {

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

  package { $sys_packages:
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

  php::module { $php_modules: }

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
    mysql_db             => $mysql_db,
    mysql_user           => $mysql_user,
    mysql_password       => $mysql_pass,
    mysql_host           => $mysql_host,
    mysql_grant_filepath => '/home/vagrant/puppet-mysql',
  }

  $pma_facts = "mysql_root_password=${mysql_root_pass}
  controluser_password=${pma_pass}"

  file { "/etc/phpmyadmin.facts":
    owner   => root,
    group   => root,
    mode    => 664,
    content => $pma_facts,
  }

  class { 'phpmyadmin':
    require => Class['mysql'],
  }

  apache::vhost { 'phpmyadmin':
    server_name => false,
    docroot     => '/usr/share/phpmyadmin',
    port        => $pma_port,
    priority    => '10',
    require     => Class['phpmyadmin'],
    template    => 'vagrantee/apache/vhost.conf.erb',
  }
}