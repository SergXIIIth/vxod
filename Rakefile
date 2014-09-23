require "bundler/gem_tasks"

desc 'Run web server for example app'
task 'web' do
  system "bundle exec rerun --pattern '{**/*.rb}' -c 'puma --dir example'"
end

desc 'Console'
task 'console' do
  system "bundle exec irb -r ./example/app.rb"
end

desc 'Rub tests'
task 'test' do
  system %Q(bundle exec rerun --pattern '{**/*.rb}' -cx 'rspec -t ~feature --format documentation')
end

# for CI
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)
task :default  => :spec
