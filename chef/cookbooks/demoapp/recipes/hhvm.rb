include_recipe 'hhvm'

cookbook_file '/etc/default/hhvm' do
  notifies :restart, 'service[hhvm]'
end

cookbook_file '/etc/hhvm/server.ini' do
  notifies :restart, 'service[hhvm]'
end

cookbook_file '/etc/hhvm/php.ini' do
  notifies :restart, 'service[hhvm]'
end

service 'hhvm' do
  supports :status => true, :restart => true, :reload => true
  action [ :enable, :start ]
end
