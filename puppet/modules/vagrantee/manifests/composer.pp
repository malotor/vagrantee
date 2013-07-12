class vagrantee::composer (

) {

  exec { "curl -sS https://getcomposer.org/installer | php":
    cwd     => "/home/vagrant",
    creates => "/home/vagrant/composer.phar",
    require => [ Class[ php ], Package[ curl ] ]
  }

  exec { "mv composer.phar /usr/local/bin/composer":
    cwd     => "/home/vagrant",
    creates => "/usr/local/bin/composer",
    require => Exec ["curl -sS https://getcomposer.org/installer | php"]
  }

}