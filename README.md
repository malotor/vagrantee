vagrantee
=========

A basic vagrant + puppet setup for PHP development environments, as explained in details on this post:
http://www.erikaheidi.com/2013/07/10/a-beginners-guide-to-vagrant-and-puppet-part-3-facts-conditionals-modules-and-templates/

It comes with:

* Apache
* PHP 5.4
* MySQL
* phpmyadmin
* composer

more customization options are being planned.

Make sure you have both Vagrant and Virtualbox properly installed:
http://www.erikaheidi.com/2013/07/02/a-begginers-guide-to-vagrant-getting-your-portable-development-environment/

simple usage
=========

If you just want to test vagrantee, this is the easier way.

<h4>Clone vagrantee repository</h4>

``git clone https://github.com/vagrantee/vagrantee.git``

Init and update the submodules (puppet modules are added as submodules)

``git submodule init``


``git submodule update``

<h4>Run vagrant</h4>

``vagrant up``

<h4>That's it</h4>
After the machine is provisioned, go to http://192.168.33.101 in your browser, you shall see a phpinfo() from your VM.

<h4>phpmyadmin</h4>
=====

phpmyadmin will be available at http://192.168.33.101:8000

login: root, password: root

usage - as a puppet module
===========

If you want to use vagrantee in an existent project while maintaining the puppet modules always up-to-date, you can add vagrantee as a git submodule.
This way you have more flexibility for setting more customizations. Vagrantee itself will manage the other git submodules (puppet modules).

``git submodule add https://github.com/vagrantee/vagrantee``

Then go the vagrantee directory and run

``git submodule init``


``git submodule update``

And all the puppet modules will be initialized.

Now copy the Vagrantfile-project.example to your project root folder and rename it for <strong>Vagrantfile</strong>.
By default, it will use the vagrantee/manifests/default.pp manifest , but you can use your own manifests, just change the path on the Vagrantfile to your own manifests path.
Then you can set up specific settings by declaring the vagrantee module with some arguments, and also create additional configurations.


