class drupal (
  $doc_root        = '/vagrant/web',
  $mysql_host      = 'localhost',
  $mysql_db        = 'dbname',
  $mysql_user      = 'dbuser',
  $mysql_pass      = 'dbuser01',
) {
  #Drupal configuration

  exec { "create_sites_dir" :
    command => "mkdir -p ${doc_root}/sites/default/"
  }

  file { 'settings_file' :
    path => "${doc_root}/sites/default/settings.php",
    ensure => 'present',
    content       =>  template("drupal/settings.php.erb"),
    require => Exec['create_sites_dir']
  }
}