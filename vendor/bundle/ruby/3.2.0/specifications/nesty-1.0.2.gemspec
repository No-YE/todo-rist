# -*- encoding: utf-8 -*-
# stub: nesty 1.0.2 ruby lib

Gem::Specification.new do |s|
  s.name = "nesty".freeze
  s.version = "1.0.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alan Skorkin".freeze]
  s.date = "2013-04-12"
  s.description = "Nested exception support for Ruby".freeze
  s.email = ["alan@skorks.com".freeze]
  s.homepage = "https://github.com/skorks/nesty".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Nested exception support for Ruby".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_development_dependency(%q<bundler>.freeze, ["~> 1.3"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
  s.add_development_dependency(%q<travis-lint>.freeze, [">= 0"])
end
