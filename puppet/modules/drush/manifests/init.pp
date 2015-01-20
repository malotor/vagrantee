class drush (
) {

  exec { "composer global require drush/drush:dev-master":
    cwd     => "/home/vagrant",
  }

  exec { "composer global update":
    cwd     => "/home/vagrant",
  }

}