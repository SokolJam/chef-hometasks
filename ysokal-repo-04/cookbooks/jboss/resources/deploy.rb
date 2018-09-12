#
# Cookbook:: nginx
# Recipe:: install
#
# Copyright:: 2018, Yauheni Sokal, All Rights Reserved.

resource_name :app_deploy

property :version, String, default: '0.0.1'
property :file, String, required: true
property :path, String, required: true

default_action :deploy

load_current_value do
  version
end 


action :deploy do
  converge_if_changed :version do
    cookbook_file "#{new_resource.path}/#{new_resource.file}" do
      source new_resource.file
      owner 'jboss'
      group 'jboss'
    end
  end
end
