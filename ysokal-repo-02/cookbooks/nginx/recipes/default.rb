#
# Cookbook:: nginx
# Recipe:: default
#
# Copyright:: 2018, Yauheni Sokal, All Rights Reserved.

include_recipe 'nginx-repo'

package 'nginx' do
  action :install
end

service 'nginx' do
  action [:enable, :start]
end

template '/etc/nginx/conf.d/jboss.conf' do
  source 'jboss.conf.erb'
  variables(ip_nginx: node["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
            ip_jboss: search(:node, 'roles:jboss')[0]["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first,
            port_nginx: node['nginx']['port'],
            port_jboss: node['jboss']['port'],
            dest_app: node['jboss']['path'])
  notifies :restart, 'service[nginx]'
end

template '/usr/share/nginx/html/info.html' do
  source 'info.erb'
  variables(info: search(:nginx_bag, 'id:nginx_item')[0]['key'])
  notifies :restart, "service[nginx]"
end
