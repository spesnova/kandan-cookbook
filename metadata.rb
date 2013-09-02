name             'kandan'
maintainer       'Seigo Uchida'
maintainer_email 'spesnova@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures kandan'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.1.0'

%w{
  centos
  redhat
}.each do |os|
  supports os
end

%w{
  git
  application_ruby
  database
  mysql
}.each do |cb|
  depends cb
end
