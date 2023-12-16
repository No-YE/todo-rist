# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model

  enum status: { initial: 0, summarizing: 1, completed: 2, failed: 3 }

  belongs_to :user

  validates :url, presence: true, url: true
  validate :sanitized_url, presence: true, url: true

  attr_readonly :sanitized_url

  def self.build_initial(params)
    new(params.merge(status: :initial))
  end

  def url=(value)
    super

    parsed_url = URI.parse(value)
    parsed_url.fragment = nil
    self.sanitized_url = parsed_url.to_s
  end
end
