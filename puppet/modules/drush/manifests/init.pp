class drush (
) {
  exec { "composer global require drush/drush:dev-master":
    require => Class['composer'],
  }
  exec { "composer global update":
    require => Exec ["composer global require drush/drush:dev-master"]
  }
}