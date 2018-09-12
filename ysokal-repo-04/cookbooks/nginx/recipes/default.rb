#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, All Rights Reserved.
#Chef::Log.warn('The default tomcat recipe does nothing. See the readme for information on using the tomcat resources')

nginx_install "custom" do
  version node['nginx']['version']
  ip_nginx lazy { search(:node, 'roles:nginx')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first }
  ip_jboss lazy { search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first }
  text_info lazy { search(:nginx_bag, 'id:nginx_item')[0]['key'] }
  port node['nginx']['port']
  proxy_port node['jboss']['port']
  app_path node['jboss']['path']
end

