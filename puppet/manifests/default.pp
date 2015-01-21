/*********************************************************************
* Default manifest file using Vagrantee module
* see modules/vagrantee/manifests/init.pp for the module parameters
**********************************************************************/

class { 'project':
  doc_root        => '/vagrant/web',
  mysql_db        => 'drupal',
  mysql_user      => 'drupal',
  mysql_pass      => 'drupal01',
}