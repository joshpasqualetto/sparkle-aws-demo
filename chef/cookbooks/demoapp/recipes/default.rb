#
# Cookbook Name:: demoapp
# Recipe:: default
#
# Copyright 2016, Demo Inc
#
# Completely Free
#

# This should be refactored into a base cookbook
include_recipe 'apt'
include_recipe 'apt::unattended-upgrades'
include_recipe 'os-hardening'
include_recipe 'users::sysadmins'

package 'git'

include_recipe 'demoapp::hhvm'
include_recipe 'demoapp::nginx'

mysql_service 'demoapp' do
  port '3306'
  version '5.6'
  initial_root_password 'changeit'
  action [:create, :start]
end

group node[:demoapp][:user]

user node[:demoapp][:user] do
  home node[:demoapp][:home]
  group node[:demoapp][:user] 
  supports :manage_home => true
  system true
  shell '/bin/bash'
end

deploy_revision node[:demoapp][:home] do
  revision node[:demoapp][:revision]
  user node[:demoapp][:user]
  repository node[:demoapp][:repo]
  symlinks Hash.new
  purge_before_symlink Array.new
  create_dirs_before_symlink Array.new
  symlink_before_migrate Hash.new
  migrate false

  before_migrate do
  end

  notifies :restart, 'service[hhvm]'
end
