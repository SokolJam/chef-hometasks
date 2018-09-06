#
# Cookbook:: task1_community
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.

include_recipe 'tomcat'

tomcat_install 'helloworld' do
  version '8.0.36'
end



