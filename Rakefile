require "bundler/gem_tasks"

desc 'Run web server for example app'
task 'web' do
  system "cd example; bundle exec rerun --pattern '{**/*.rb}' -c 'puma -p 3000'"
end

desc 'Console'
task 'console' do
  system "bundle exec irb -r ./example/app.rb"
end

desc 'Rub tests'
task 'test' do
  system %Q(bundle exec rerun --pattern '{**/*.rb}' -cx rspec)
end