#
# Cookbook Name:: demoapp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

# This should be refactored into a base cookbook
include_recipe 'apt'
include_recipe 'apt::unattended-upgrades'
include_recipe 'os-hardening'
include_recipe 'users::sysadmins'

include_recipe 'hhvm'

service 'hhvm' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end

cookbook_file '/etc/default/hhvm' do
  notifies :restart, 'service[hhvm]'
end

cookbook_file '/etc/hhvm/server.ini' do
  notifies :restart, 'service[hhvm]'
end

cookbook_file '/etc/hhvm/php.ini' do
  notifies :restart, 'service[hhvm]'
end

include_recipe 'nginx'

mysql_service 'demoapp' do
  port '3306'
  version '5.6'
  initial_root_password 'changeit'
  action [:create, :start]
end

package 'git'

# Don't actually do this, use the nginx cookbook.
cookbook_file '/etc/nginx/sites-enabled/demoapp' do
  notifies :restart, 'service[nginx]'
end

file '/etc/nginx/sites-enabled/default' do
  notifies :restart, 'service[nginx]'
  action :delete
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

  restart do
    # You should use a real process supervisor here, runit, etc.
    # This does not handle updates to the application
    execute 'Start hhvm' do
      command 'hhvm -m server -p 8080 &'
      cwd release_path
      user node[:demoapp][:user]
    end
  end
end
