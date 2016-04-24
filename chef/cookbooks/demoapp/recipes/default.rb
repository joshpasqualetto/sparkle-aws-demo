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
package 'nginx'

# Don't actually do this, use the nginx cookbook.
cookbook_file '/etc/nginx/sites-enabled/demoapp' do
  notifies :restart, 'service[nginx]'
end

file '/etc/nginx/sites-enabled/default' do
  notifies :restart, 'service[nginx]'
  action :delete
end

service 'nginx' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
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
    execute 'Run Bundler' do
      command 'bundle install --path=vendor/bundle'
      cwd release_path
      user node[:demoapp][:user]
    end
  end

  restart do
    # You should use a real process supervisor here, runit, etc.
    # This does not handle updates to the application
    execute 'Start puma' do
      command 'bundle exec puma -d --pidfile /opt/demoapp/shared/puma.pid'
      environment "HOME" => node[:demoapp][:home],
                  "PWD" => node[:demoapp][:home]
      cwd release_path
      user node[:demoapp][:user]
    end
  end
end
