# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model

  enum state: { initial: 0, summarizing: 1, completed: 2, failed: 3 }

  belongs_to :user

  validates :url, presence: true
  validates :sanitized_url, presence: true

  attr_readonly :sanitized_url

  default_scope -> { kept }
  scope :with_url, ->(url) { where(sanitized_url: generate_sanitized_url(url)) }

  def self.build_initial(params)
    new(params.merge(state: :initial))
  end

  def self.generate_sanitized_url(url)
    parsed_url = URI.parse(url)
    parsed_url.fragment = nil
    parsed_url.to_s
  end

  def url=(value)
    super

    self.sanitized_url = Link.generate_sanitized_url(value)
  end

  def clone(user)
    raise ArgumentError, 'Link must be completed to be cloned' unless completed?

    dup.tap do |link|
      link.user = user
      link.save!
    end
  end
end
