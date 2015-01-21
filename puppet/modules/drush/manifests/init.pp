class drush (
  $version = '7.0.0-alpha8'
) {

  exec { 'drush_clone_repo':
    command => "git clone https://github.com/drush-ops/drush.git /usr/local/src/drush",
    require => Package[ 'git' ],
    creates => '/usr/local/src/drush',
    user => 'root'
  }
  exec { "drush_checkoug":
    command => "git checkout $version",
    cwd     => '/usr/local/src/drush',
    require => Exec['drush_clone_repo']
  }
  exec { "drush_link":
    command => "ln -s /usr/local/src/drush/drush /usr/bin/drush",
    creates => '/usr/bin/drush',
    require => Exec['drush_checkoug']
  }
  exec { "composer install":
    cwd     => '/usr/local/src/drush',
    require => Exec['drush_link']
  }


}