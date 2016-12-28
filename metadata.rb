name             'hygieia-liatrio'
maintainer       'Liatrio'
maintainer_email 'drew@liatrio.com'
license          'All rights reserved'
issues_url        'http://github.com/liatrio-chef/hygieia-liatrio'
source_url        'http://github.com/liatrio-chef/hygieia-liatrio'
description      'Installs/Configures hygieia-liatrio wrapper cookbook'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.6.0'

depends 'java', '~> 1.42.0'
depends 'apache2', '~> 3.2.2'
depends 'nvm', '~> 0.1.7'
