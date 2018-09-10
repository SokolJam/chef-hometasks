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
  source 'https://kent.dl.sourceforge.net/project/jboss/JBoss/JBoss-5.1.0.GA/jboss-5.1.0.GA.zip'
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

cookbook_file '/opt/jboss/server/default/deploy/test.war' do
  source 'test.war'
  owner 'jboss'
  group 'jboss'
  action :create_if_missing
end

service 'jboss' do
  action [:enable, :restart] 
end

