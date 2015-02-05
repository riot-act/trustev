require 'bundler/gem_tasks'
require 'rake/testtask'

Rake::TestTask.new do |t|
  t.test_files = FileList["test/#{ENV['TRUSTEV_VERSION']}/*_test.rb"]
  t.verbose = true
end

Rake::TestTask.new('test:2.0:critical') do |t|
  t.test_files = %w(test/2.0/case_test.rb test/2.0/decision_test.rb test/2.0/status_test.rb)
end
