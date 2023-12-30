# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model
  include Link::Scraping
  include Link::Searchable
  include Link::Readable

  belongs_to :user

  validates :url, presence: true
  validates :sanitized_url, presence: true

  after_update_commit do
    broadcast_replace_to 'links', locals: { link: self, current_user: user }
  end
  after_discard -> { broadcast_remove_to 'links' }

  attr_readonly :sanitized_url

  scope :with_url, ->(url) { where(sanitized_url: generate_sanitized_url(url)) }

  def self.generate_sanitized_url(url)
    parsed_url = URI.parse(url)
    parsed_url.fragment = nil
    parsed_url.to_s
  end

  def url=(value)
    super

    self.sanitized_url = Link.generate_sanitized_url(value)
  end

  def clone!(user_id)
    raise ArgumentError, 'Link must be completed to be cloned' unless completed?

    dup.tap do |link|
      link.user_id = user_id
      link.save!
    end
  end
end
