puppet-composer
===============

A simple composer module for puppet.

<h4>Requirements</h4>
You need curl and php installed before using this module. Both shall be defined as requirements.

example usage
===============

``  class { 'composer':
      require => [ Class[ 'php' ], Package[ 'curl' ] ]
    }``
