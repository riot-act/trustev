require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList["test/#{ENV['VERSION']}/*_test.rb"]
  t.verbose = true
end
