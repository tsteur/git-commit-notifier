# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{git-commit-notifier}
  s.version = IO.read('VERSION').chomp

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Bodo Tasche", "Akzhan Abdulin"]
  s.date = Time.now.strftime('%Y-%m-%d')
  s.description = %q{This git commit notifier sends html mails with nice diffs for every changed file.}
  s.email = %q{bodo@bitboxer.de}
  s.extra_rdoc_files = [
    "LICENSE",
    "README.textile"
  ]

  s.files            = `git ls-files`.split("\n")
  s.test_files       = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables      = `git ls-files -- bin/*`.split("\n").map { |f| File.basename(f) }

  s.homepage = %q{http://github.com/bitboxer/git-commit-notifier}
  s.require_paths = ["lib"]
  s.rubygems_version = %q{1.3.7}
  s.summary = %q{Sends git commit messages with diffs}

  s.specification_version = 3

  s.add_runtime_dependency(%q<diff-lcs>, [">= 0"])
  s.add_runtime_dependency(%q<nntp>, [">= 0"])
  s.add_runtime_dependency(%q<premailer>, [">= 1.7.1"])
  s.add_runtime_dependency(%q<nokogiri>, [">= 1.4.4"])
  s.add_development_dependency(%q<bundler>, [">= 1.0.10"])
  s.add_development_dependency(%q<code-cleaner>, [">= 0"])
  s.add_development_dependency(%q<rspec-core>, [">= 0"])
  s.add_development_dependency(%q<rspec-expectations>, [">= 0"])
  s.add_development_dependency(%q<rr>, [">= 0"])
  s.add_development_dependency(%q<faker>, [">= 0"])
  s.add_development_dependency(%q<rcov>, [">= 0"])
  s.add_development_dependency(%q<metric_fu>, [">= 0"])
end

