#
# Cookbook Name:: demoapp
# Recipe:: default
#
# Copyright 2016, Demo Inc
#
# Completely Free
#

package 'git'

# This should be refactored into a base cookbook
include_recipe 'apt'
include_recipe 'apt::unattended-upgrades'
include_recipe 'demoapp::nginx'

directory '/opt/demoapp' do
  owner 'www-data'
  group 'www-data'
  mode 0755
  recursive true
end

file '/opt/demoapp/index.html' do
  owner 'www-data'
  group 'www-data'
  mode 0644
  content 'Automation for the People'
end
