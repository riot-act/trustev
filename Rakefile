require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList["test/#{ENV['TRUSTEV_VERSION']}/*_test.rb"]
  t.verbose = true
end
