# -*- encoding: utf-8 -*-
# stub: repo-small-badge 0.2.10 ruby lib

Gem::Specification.new do |s|
  s.name = "repo-small-badge".freeze
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Marc Grimme".freeze]
  s.date = "2023-10-03"
  s.description = "Small Badge generator to be used for different tools 4 ruby.\nExamples rubycritic and simplecov.".freeze
  s.email = ["marc.grimme at gmail dot com".freeze]
  s.executables = ["console".freeze]
  s.files = ["bin/console".freeze]
  s.homepage = "https://github.com/marcgrimme/repo-small-badge".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 3.2".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Small Badge generator to be used for different tools 4 ruby".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<victor>.freeze, ["~> 0.3.0"])
  s.add_development_dependency(%q<rake>.freeze, ["~> 13"])
  s.add_development_dependency(%q<rspec>.freeze, ["~> 3.8"])
  s.add_development_dependency(%q<rubocop>.freeze, ["~> 1.0"])
  s.add_development_dependency(%q<rubycritic>.freeze, ["~> 4.1"])
  s.add_development_dependency(%q<rubycritic-small-badge>.freeze, ["~> 0"])
  s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.18"])
  s.add_development_dependency(%q<simplecov-small-badge>.freeze, ["~> 0.2.2"])
end
