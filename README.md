vagrantee
=========

A basic vagrant + puppet setup for php development environments, as explained in details on this post:
http://www.erikaheidi.com/2013/07/10/a-beginners-guide-to-vagrant-and-puppet-part-3-facts-conditionals-modules-and-templates/

It comes with:

* Apache
* PHP 5.4
* MySQL
* phpmyadmin

usage
=========

Make sure you have both Vagrant and Virtualbox properly installed:
http://www.erikaheidi.com/2013/07/02/a-begginers-guide-to-vagrant-getting-your-portable-development-environment/

1. Clone vagrantee repository

``git clone https://github.com/erikaheidi/vagrantee.git``

2. Init and update the submodules (puppet modules are added as submodules)

``git submodule init``
``git submodule update``

3. Run vagrant

``vagrant up``

4. Check if everything is ok (after the machine is provisioned)

Go to http://192.168.33.101 in your browser, you shall see a phpinfo() from your VM.

phpmyadmin
=====

phpmyadmin will be available at http://192.168.33.101:8000

l: root
p: root