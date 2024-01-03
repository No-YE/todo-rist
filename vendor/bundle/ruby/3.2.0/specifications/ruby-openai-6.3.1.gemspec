# -*- encoding: utf-8 -*-
# stub: ruby-openai 6.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "ruby-openai".freeze
  s.version = "6.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.metadata = { "changelog_uri" => "https://github.com/alexrudall/ruby-openai/blob/main/CHANGELOG.md", "homepage_uri" => "https://github.com/alexrudall/ruby-openai", "rubygems_mfa_required" => "true", "source_code_uri" => "https://github.com/alexrudall/ruby-openai" } if s.respond_to? :metadata=
  s.require_paths = ["lib".freeze]
  s.authors = ["Alex".freeze]
  s.bindir = "exe".freeze
  s.date = "2023-12-04"
  s.email = ["alexrudall@users.noreply.github.com".freeze]
  s.homepage = "https://github.com/alexrudall/ruby-openai".freeze
  s.licenses = ["MIT".freeze]
  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0".freeze)
  s.rubygems_version = "3.4.10".freeze
  s.summary = "OpenAI API + Ruby! \u{1F916}\u{1FA75}".freeze

  s.installed_by_version = "3.4.10" if s.respond_to? :installed_by_version

  s.specification_version = 4

  s.add_runtime_dependency(%q<event_stream_parser>.freeze, [">= 0.3.0", "< 2.0.0"])
  s.add_runtime_dependency(%q<faraday>.freeze, [">= 1"])
  s.add_runtime_dependency(%q<faraday-multipart>.freeze, [">= 1"])
end
