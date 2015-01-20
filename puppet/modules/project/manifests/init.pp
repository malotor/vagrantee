class project (
) {
  file { '/vagrant/web/sites/default/settings.php':
    source       => "puppet:///modules/proyect/settings.php",
  }
}