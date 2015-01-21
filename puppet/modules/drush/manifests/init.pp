class drush (
) {
  /*
  file { 'drush_copy_install_script' :
    path => '/home/vagrant/install_drush.sh',
    source  => "puppet:///modules/drush/install_drush.sh",
    mode => 0775
  }

  exec { "drush_exec_script":
    command => "install_drush.sh",
    path => '/home/vagrant',
    require => [ File['drush_copy_install_script'] , Package["git"]],
  }
  */
  /*
  git::clone {
    repository => "https://github.com/drush-ops/drush.git",
    path =>'/usr/local/src/drush',
  }
  */
  exec { 'drush_clone_repo':
    command => "git clone https://github.com/drush-ops/drush.git /usr/local/src/drush",
    require => Package[ 'git' ],
    creates => '/usr/local/src/drush',
    user => 'root'
  }
  exec { "drush_checkoug":
    command => 'git checkout 7.0.0-alpha5',
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

  /*
  exec { "composer_add_path":
    command => "sed -i '1i export PATH=\"\$HOME/.composer/vendor/bin:\$PATH\"' \$HOME/.bashrc",
    require => Class['composer'],
  }

  exec { "source \$HOME/.bashrc":
    require => Exec["composer_add_path"],
  }


  exec { "composer global require drush/drush:dev-master":
    require => Exec["composer_add_path"],
  }
  exec { "composer global update":
    require => Exec ["composer global require drush/drush:dev-master"]
  }
  */

}