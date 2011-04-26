require 'rubygems'
require 'rake'

APP_ROOT = File.dirname(__FILE__).freeze

begin
  require 'bundler'
  Bundler::GemHelper.install_tasks
rescue LoadError
  puts "Bundler not available. Install it with: gem install bundler"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new

  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.ruby_opts = '-w'
    t.rcov_opts = %q[-Ilib --exclude "spec/*,gems/*"]
  end
rescue LoadError
  $stderr.puts "RSpec not available. Install it with: gem install rspec-core rspec-expectations"
end

task :default => :spec

begin
  require 'metric_fu'
rescue LoadError
  $stderr.puts "metric_fu not available. Install it with: gem install metric_fu"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exists?('VERSION') ? IO.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "git-commit-notifier #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

begin
  gem 'code-cleaner'
  desc 'Clean code for whitespaces and tabs'
  task :'code:clean' do
    system('code-cleaner lib spec Rakefile bin/git-commit-notifier')
  end
rescue LoadError
  $stderr.puts "code-cleaner not available. Install it with: gem install code-cleaner"
end

