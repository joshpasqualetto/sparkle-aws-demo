include_recipe 'nginx'

# Don't actually do this, use the nginx cookbook LWRPs
cookbook_file '/etc/nginx/sites-enabled/demoapp' do
  notifies :restart, 'service[nginx]'
end

file '/etc/nginx/sites-enabled/default' do
  notifies :restart, 'service[nginx]'
  action :delete
end
