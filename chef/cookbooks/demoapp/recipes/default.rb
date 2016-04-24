#
# Cookbook Name:: demoapp
# Recipe:: default
#
# Copyright 2016, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

package 'ruby1.9.3'
package 'bundler'

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
    execute 'Run Bundler' do
      command 'bundle install'
      cwd release_path
      user node[:demoapp][:user]
    end
  end

  restart do
  end
end
