require 'rubygems'
require 'rake'

APP_ROOT = File.dirname(__FILE__).freeze

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "git-commit-notifier"
    gem.summary = %Q{Sends git commit messages with diffs}
    gem.description = %Q{This git commit notifier sends html mails with nice diffs for every changed file.}
    gem.email = "bodo@bitboxer.de"
    gem.homepage = "http://github.com/bitboxer/git-commit-notifier"
    gem.authors = ["Bodo Tasche"]
    gem.add_dependency('diff-lcs')
    gem.add_dependency('premailer', '>=1.5.6')
    gem.add_development_dependency('hpricot') # FIXME: Move to Nokogiri
    gem.add_development_dependency('rspec-core')
    gem.add_development_dependency('rspec-expectations')
    gem.add_development_dependency('rr')
    gem.add_development_dependency('faker')
    gem.add_development_dependency('rcov')
    gem.add_development_dependency('metric_fu')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new do |t|
    t.rspec_opts = ["-c", "-f progress"]
  end

  RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.ruby_opts = '-w'
    t.rspec_opts = ["-c", "-f progress"]
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

