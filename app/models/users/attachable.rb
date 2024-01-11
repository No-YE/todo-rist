# frozen_string_literal: true

require 'open-uri'

module Users::Attachable
  extend ActiveSupport::Concern

  included do
    has_one_attached :avatar

    validates :avatar, content_type: %i[png jpg jpeg], size: { less_than: 1.megabyte }
  end

  def attach_avatar_from(url)
    filename = File.basename(URI.parse(url).path)
    io = URI.open('https://meme.eq8.eu/noidea.jpg')
    avatar.attach(io:, filename:)
  end
end
