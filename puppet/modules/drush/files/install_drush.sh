#!/bin/sh
git clone https://github.com/drush-ops/drush.git /usr/local/src/drush
cd /usr/local/src/drush
git checkout 7.0.0-alpha5  #or whatever version you want.
ln -s /usr/local/src/drush/drush /usr/bin/drush
composer install