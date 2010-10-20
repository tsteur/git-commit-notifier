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
    gem.add_dependency('mocha')
    gem.add_dependency('hpricot')
    gem.add_dependency('tamtam')
  end
  Jeweler::GemcutterTasks.new
rescue LoadError
  puts "Jeweler (or a dependency) not available. Install it with: gem install jeweler"
end

begin
  require 'spec/rake/spectask'
  Spec::Rake::SpecTask.new do |t|
    t.warning = true
    t.rcov    = false
  end
  Spec::Rake::SpecTask.new do |t|
    t.name    = :'spec:rcov'
    t.warning = true
    t.rcov    = true
    t.rcov_opts = lambda do
      IO.readlines("#{APP_ROOT}/spec/rcov.opts").map {|l| l.chomp.split " "}.flatten
    end
  end
rescue LoadError
  $stderr.puts "RSpec not available. Install it with: gem install rspec"
end

task :default => :spec

begin
  require 'metric_fu'
rescue LoadError
  $stderr.puts "metric_fu not available. Install it with: gem install metric_fu"
end

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "git-commit-notifier #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

