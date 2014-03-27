require "bundler/gem_tasks"

desc 'Run web server for example app'
task 'web' do
  system "bundle exec rerun --pattern '{**/*.rb}' -c 'puma -p 3000 --dir example'"
end

desc 'Console'
task 'console' do
  system "bundle exec irb -r ./example/app.rb"
end

desc 'Rub tests'
task 'test' do
  system %Q(bundle exec rerun --pattern '{**/*.rb}' -cx rspec)
end

desc 'Rub feature tests'
task 'test_feature' do
  system %Q(bundle exec rspec -t feature)
end