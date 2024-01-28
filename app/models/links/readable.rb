# frozen_string_literal: true

module Links::Readable
  extend ActiveSupport::Concern

  included do
    scope :read, -> { where.not(read_at: nil) }
    scope :unread, -> { where(read_at: nil) }
  end

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

  def must_read?
    unread? && due_date.present?
  end
end
