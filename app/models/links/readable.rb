# frozen_string_literal: true

module Links::Readable
  extend ActiveSupport::Concern

  def read!
    update!(read_at: Time.current)
  end

  def unread!
    update!(read_at: nil)
  end

  def read?
    read_at.present?
  end

  def unread?
    !read?
  end
end