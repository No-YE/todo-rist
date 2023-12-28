# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model
  include Link::Scraping

  belongs_to :user

  validates :url, presence: true
  validates :sanitized_url, presence: true

  attr_readonly :sanitized_url

  default_scope -> { kept }
  scope :with_url, ->(url) { where(sanitized_url: generate_sanitized_url(url)) }

  def self.clone_or_create!(user_id, url)
    exist_link = with_url(url).completed.order(id: :desc).first

    if exist_link.present?
      exist_link.clone(user_id)
    else
      create!(user_id:, url:, scraping_state: :initial)
    end
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

  def clone(user_id)
    raise ArgumentError, 'Link must be completed to be cloned' unless completed?

    dup.tap do |link|
      link.user_id = user_id
      link.save!
    end
  end
end
