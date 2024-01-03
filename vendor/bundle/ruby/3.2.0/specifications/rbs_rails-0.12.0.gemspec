# -*- encoding: utf-8 -*-
# stub: rbs_rails 0.12.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rbs_rails".freeze
  s.version = "0.12.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/pocke/rbs_rails/blob/master/CHANGELOG.md", "homepage_uri" => "https://github.com/pocke/rbs_rails", "source_code_uri" => "https://github.com/pocke/rbs_rails" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Masataka Pocke Kuwabara".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-04-27"
  s.description = "A RBS files generator for Rails application".freeze
  s.email = ["kuwabara@pocke.me".freeze]
  s.homepage = "https://github.com/pocke/rbs_rails".freeze
  s.licenses = ["Apache-2.0".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.3.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "A RBS files generator for Rails application".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<parser>.freeze, [">= 0"])
  s.add_runtime_dependency(%q<rbs>.freeze, [">= 1"])
end
