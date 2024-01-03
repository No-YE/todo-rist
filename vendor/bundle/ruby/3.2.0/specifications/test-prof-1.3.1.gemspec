# -*- encoding: utf-8 -*-
# stub: test-prof 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "test-prof".freeze
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "bug_tracker_uri" => "https://github.com/test-prof/test-prof/issues", "changelog_uri" => "https://github.com/test-prof/test-prof/blob/master/CHANGELOG.md", "documentation_uri" => "https://test-prof.evilmartians.io/", "funding_uri" => "https://github.com/sponsors/test-prof", "homepage_uri" => "https://test-prof.evilmartians.io/", "source_code_uri" => "https://github.com/test-prof/test-prof" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Vladimir Dementyev".freeze]
  s.date = "2023-12-12"
  s.description = "\n    Ruby applications tests profiling tools.\n\n    Contains tools to analyze factories usage, integrate with Ruby profilers,\n    profile your examples using ActiveSupport notifications (if any) and\n    statically analyze your code with custom RuboCop cops.\n  ".freeze
  s.email = ["dementiev.vm@gmail.com".freeze]
  s.homepage = "http://github.com/test-prof/test-prof".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.5.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Ruby applications tests profiling tools".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, [">= 1.16"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13.0"])
  s.add_development_dependency(%q<rspec-rails>.freeze, [">= 4.0"])
  s.add_development_dependency(%q<isolator>.freeze, [">= 0.6"])
  s.add_development_dependency(%q<minitest>.freeze, [">= 5.9"])
  s.add_development_dependency(%q<rubocop>.freeze, [">= 0.77.0"])
end
