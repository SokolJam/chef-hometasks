#
# Cookbook:: task1_apache
# Recipe:: default
#
# Copyright:: 2018, Yauheni Sokal, All Rights Reserved.

package 'httpd'
package 'php'

file '/var/www/html/info.php' do
  content '<?php phpinfo(); ?>'
  notifies :restart, "service[httpd]"
end

service 'httpd' do
  action [:enable, :start]
end
