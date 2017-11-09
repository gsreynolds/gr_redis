name 'gr_redis'
maintainer 'Gavin Reynolds'
maintainer_email 'gsreynolds@gmail.com'
license 'Apache-2.0'
description 'Installs/Configures Redis'
long_description 'Installs/Configures Redis'
version '1.0.0'
chef_version '>= 12.5' if respond_to?(:chef_version)

depends 'build-essential'

supports 'debian'
supports 'ubuntu'
supports 'redhat'
supports 'centos'
supports 'fedora'

issues_url 'https://github.com/gsreynolds/gr_redis/issues'
source_url 'https://github.com/gsreynolds/gr_redis'
