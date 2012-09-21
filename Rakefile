$:.unshift(File.expand_path('lib'))
require 'rokko/task'
require 'rake/testtask'

Rokko::Task.new(:rokko, 'docs', ['lib/**/*.rb', 'README.md'], {:index => true, :local => true})

Rake::TestTask.new do |t|
  t.test_files = ['test/tests.rb']
  t.verbose = true
end