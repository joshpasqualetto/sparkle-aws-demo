require 'foodcritic'
require 'rubocop/rake_task'

task default: %w[test]

namespace :test do
  sh 'bundle exec rubocop -D --format offenses --format progress --fail-level W'
  sh 'bundle exec foodcritic chef/cookbooks'
  ruby "test/testharness.rb"
end

begin
  require 'kitchen/rake_tasks'
  Kitchen::RakeTasks.new
rescue LoadError
  puts '>>>>> Kitchen gem not loaded, omitting tasks' unless ENV['CI']
end

