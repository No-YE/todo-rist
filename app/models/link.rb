# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model
  include Links::Scraping
  include Links::Searchable
  include Links::Readable
  include Links::Remindable

  belongs_to :user

  validates :url, presence: true, uniqueness: { scope: :user_id }
  validates :user_id, presence: true
  validates :due_date,
            comparison: { greater_than_or_equal_to: -> { Time.current.to_date }, allow_nil: true }

  after_update_commit do
    broadcast_replace_to 'links', locals: { link: self, current_user: user }
  end
  after_discard -> { broadcast_remove_to 'links' }

  def clone(user_id)
    dup.tap do |link|
      link.user_id = user_id
      link.due_date = nil
      link.created_at = nil
    end
  end
end
