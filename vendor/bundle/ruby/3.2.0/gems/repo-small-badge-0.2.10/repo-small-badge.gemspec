# frozen_string_literal: true

$LOAD_PATH.push File.expand_path('lib', __dir__)
require 'repo_small_badge/version'

Gem::Specification.new do |s|
  s.required_ruby_version = '>=3.2'
  s.name        = 'repo-small-badge'
  s.version     = RepoSmallBadge::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ['Marc Grimme']
  s.email       = ['marc.grimme at gmail dot com']
  s.license     = 'MIT'
  s.homepage    = 'https://github.com/marcgrimme/repo-small-badge'
  s.summary     = %(Small Badge generator to be used for different tools 4 ruby)
  s.description = %(Small Badge generator to be used for different tools 4 ruby.
Examples rubycritic and simplecov.)

  s.rubyforge_project = 'repo-small-badge'

  s.add_dependency 'victor', '~> 0.3.0' # to create the svg
  s.add_development_dependency 'rake', '~> 13'
  s.add_development_dependency 'rspec', '~> 3.8'
  s.add_development_dependency 'rubocop', '~> 1.0'
  s.add_development_dependency 'rubycritic', '~> 4.1'
  s.add_development_dependency 'rubycritic-small-badge', '~> 0'
  s.add_development_dependency 'simplecov', '~> 0.18'
  s.add_development_dependency 'simplecov-small-badge', '~> 0.2.2'

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`
                    .split("\n").map { |f| File.basename(f) }
  s.require_paths = ['lib']
end
