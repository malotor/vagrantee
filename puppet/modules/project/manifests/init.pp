class project (
  $doc_root        = '/vagrant/web',
  $php_modules     = [ 'imagick', 'xdebug', 'curl', 'mysql', 'cli', 'intl', 'mcrypt', 'memcache'],
  $sys_packages    = [ 'build-essential', 'curl', 'vim'],
  $mysql_host      = 'localhost',
  $mysql_db        = 'dbname',
  $mysql_user      = 'dbuser',
  $mysql_pass      = 'dbuser01',
  $pma_port        = '80',
  $drush_version   = '7.0.0-alpha8'
) {

  Exec { path => [ "/bin/", "/sbin/" , "/usr/bin/", "/usr/sbin/" ] }

  exec { 'apt-get update':
    command => 'apt-get update',
  }

  class { 'apt':
    always_apt_update => true,
  }

  class { 'git': }

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

  apache::vhost { 'newcibbva':
    docroot             => $doc_root,
    server_name         => 'newcibbva.dev',
    priority            => '',
    template            => 'vagrantee/apache/vhost.conf.erb',
    directory           => $doc_root,
    directory_allow_override   => 'All'
  }
  apache::vhost { 'newcibbvassl':
    docroot             => $doc_root,
    server_name         => 'newcibbva.dev',
    priority            => '',
    template            => 'vagrantee/apache/vhost.conf.erb',
    directory           => $doc_root,
    directory_allow_override   => 'All',
    port                 => '443',
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

  package { 'phpmyadmin':
    require => Class[ 'mysql' ],
  }

  apache::vhost { 'phpmyadmin':
    server_name => false,
    docroot     => '/usr/share/phpmyadmin',
    port        => '8000',
    priority    => '10',
    require     => Package['phpmyadmin'],
    template    => 'vagrantee/apache/vhost.conf.erb',
  }

  class { 'composer':
    require => [ Class[ 'php' ], Package[ 'curl' ] ]
  }



  class { 'dotfiles': }

  # Change user
  exec { "ApacheUserChange" :
    command => "sed -i 's/APACHE_RUN_USER=www-data/APACHE_RUN_USER=vagrant/' /etc/apache2/envvars",
    onlyif  => "grep -c 'APACHE_RUN_USER=www-data' /etc/apache2/envvars",
    require =>  Package["apache2"],
    notify  => Service["apache2"],
  }

  # Change group
  exec { "ApacheGroupChange" :
    command => "sed -i 's/APACHE_RUN_GROUP=www-data/APACHE_RUN_GROUP=vagrant/' /etc/apache2/envvars",
    onlyif  => "grep -c 'APACHE_RUN_GROUP=www-data' /etc/apache2/envvars",
    require =>  Package["apache2"],
    notify  => Service["apache2"],
  }

  # Change log files and logrotate permissions
  exec { "apache_logfile_permissions" :
    command => "chmod -R a+rX /var/log/apache2",
    require =>  Package["apache2"],
  }
  exec { "apache_logrotate_permissions" :
    command => "sed -i 's/640/644/' /etc/logrotate.d/apache2",
    require =>  Package["apache2"],
  }

  exec { "apache_lockfile_permissions" :
    command => "chown -R vagrant:www-data /var/lock/apache2",
    require =>  Package["apache2"],
  }

  class { 'drush':
    version => $drush_version
  }

  class { 'drupal':}

}