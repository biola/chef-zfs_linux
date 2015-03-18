name             'zfs_linux'
maintainer       'Biola University'
maintainer_email 'troy.ready@biola.edu'
license          'Apache 2.0'
description      'Installs/Configures zfs on linux'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
source_url       'https://github.com/biola/chef-zfs_linux'
issues_url       'https://github.com/biola/chef-zfs_linux/issues'
version          '2.1.1'
supports         'ubuntu'

depends          'apt'
depends          'cron'
