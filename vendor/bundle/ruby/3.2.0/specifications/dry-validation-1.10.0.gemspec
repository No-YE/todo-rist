# -*- encoding: utf-8 -*-
# stub: dry-validation 1.10.0 ruby lib

Gem::Specification.new do |s|
  s.name = "dry-validation".freeze
  s.version = "1.10.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "allowed_push_host" => "https://rubygems.org", "bug_tracker_uri" => "https://github.com/dry-rb/dry-validation/issues", "changelog_uri" => "https://github.com/dry-rb/dry-validation/blob/main/CHANGELOG.md", "source_code_uri" => "https://github.com/dry-rb/dry-validation" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Piotr Solnica".freeze]
  s.date = "2022-11-04"
  s.description = "Validation library".freeze
  s.email = ["piotr.solnica@gmail.com".freeze]
  s.homepage = "https://dry-rb.org/gems/dry-validation".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.7.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "Validation library".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<concurrent-ruby>.freeze, ["~> 1.0"])
  s.add_runtime_dependency(%q<dry-core>.freeze, ["~> 1.0", "< 2"])
  s.add_runtime_dependency(%q<dry-initializer>.freeze, ["~> 3.0"])
  s.add_runtime_dependency(%q<dry-schema>.freeze, [">= 1.12", "< 2"])
  s.add_runtime_dependency(%q<zeitwerk>.freeze, ["~> 2.6"])
  s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
  s.add_development_dependency(%q<rake>.freeze, [">= 0"])
  s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
end
