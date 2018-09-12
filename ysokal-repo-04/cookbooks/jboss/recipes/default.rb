#
# Cookbook:: jboss
# Recipe:: default
#
# Copyright:: 2018, Yauheni Sokal, All Rights Reserved.


package 'java-1.8.0-openjdk'
package 'unzip'

user 'jboss' do
  home '/opt/jboss'
  shell '/bin/bash'
end

remote_file '/tmp/jboss.zip' do
  source node['jboss']['url']
end

bash 'unzip' do
  code <<-EOH
    mkdir /opt/jboss
    unzip /tmp/jboss.zip 
    mv jboss-5.1.0.GA/* /opt/jboss/
    chown -R jboss:jboss /opt/jboss
    EOH
  not_if { ::File.exist?("/opt/jboss/server")}
end

execute 'systemctl daemon-reload' do
  command 'systemctl daemon-reload'
  action :nothing
end

template '/etc/systemd/system/jboss.service' do
  source 'jboss.service.erb'
  variables(ip_jboss: node["network"]["interfaces"]["enp0s8"]["addresses"].detect{|k,v| v[:family] == "inet" }.first)
  notifies :run, 'execute[systemctl daemon-reload]', :immediately
end

app_deploy 'test_app' do
  version node['jboss']['app_version'] 
  file 'test.war'
  path "/opt/jboss/server/default/deploy"
  action :deploy
end

service 'jboss' do
  action [:enable, :restart] 
end

