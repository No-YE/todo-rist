# frozen_string_literal: true

require 'simplecov'
require 'byebug'

module SimpleCovSmallBadge
  class Formatter
  end
end

SimpleCov.start do
  SimpleCov.formatter = SimpleCov::Formatter::MultiFormatter.new(
    [
      SimpleCov::Formatter::HTMLFormatter,
      SimpleCovSmallBadge::Formatter
    ]
  )
end

SimpleCov.minimum_coverage 100

# require 'simplecov-small-badge'
require 'repo_small_badge'
require 'simplecov_small_badge'
require 'rubygems'
require 'bundler/setup'

Dir[File.join('./spec/support/*.rb')].sort.each { |f| require f }

RSpec.configure do |config|
  # some (optional) config here
end
