#
# Cookbook:: nginx
# Recipe:: install
#
# Copyright:: 2018, Yauheni Sokal, All Rights Reserved.

resource_name :nginx_install

property :version, String, default: '1.12.0'
property :port, String, default: '80'
property :proxy_port, String, default: '8080'
property :text_info, String, default: 'Some custom DATA'
property :source, String, default: lazy { |r| "https://nginx.org/packages/centos/7/x86_64/RPMS/nginx-#{r.version}-1.el7_4.ngx.x86_64.rpm" }
property :ip_nginx, String, required: true
property :ip_jboss, String, required: true
property :app_path, String, required: true

default_action :install

action :install do
  remote_file "/tmp/nginx-#{new_resource.version}-1.el7.ngx.x86_64.rpm" do
    source "#{new_resource.source}"
  end

  rpm_package "/tmp/nginx-#{new_resource.version}-1.el7.ngx.x86_64.rpm" do
    action :install
  end

  service 'nginx' do
    action [:enable, :start]
  end

  template '/etc/nginx/conf.d/jboss.conf' do
    source 'jboss.conf.erb'
    variables(ip_nginx: new_resource.ip_nginx,
              ip_jboss: new_resource.ip_jboss,
              port_nginx: new_resource.port,
              port_jboss: new_resource.proxy_port,
              dest_app: new_resource.app_path)
    notifies :restart, 'service[nginx]'
  end

  template '/usr/share/nginx/html/info.html' do
    source 'info.erb'
    variables(info: new_resource.text_info)
    notifies :restart, "service[nginx]"
  end

end
