# frozen_string_literal: true

class Link < ApplicationRecord
  include Discard::Model
  include Links::Scraping
  include Links::Searchable
  include Links::Readable
  include Links::Remindable

  belongs_to :user
  has_one :record, dependent: :destroy, class_name: 'Links::Record'

  # rubocop:disable Rails/UniqueValidationWithoutIndex
  validates :url, presence: true, uniqueness: { scope: :user_id }
  # rubocop:enable Rails/UniqueValidationWithoutIndex
  validates :due_date,
            comparison: { greater_than_or_equal_to: -> { Time.current.to_date }, allow_nil: true },
            if: :due_date_changed?

  before_validation :set_default_due_date, if: -> { due_date.blank? }, on: :create

  acts_as_taggable_on :tags

  after_create_commit { broadcast_refresh_to [user, 'links'] }
  after_update_commit do
    I18n.with_locale(user.locale) do
      broadcast_replace_to [user, 'links'], locals: { link: self, current_user: user }
    end
    broadcast_refresh
  end
  after_discard do
    broadcast_remove_to [user, 'links']
    record.discard if record&.persisted?
  end
  after_undiscard -> { record&.undiscard }

  scope :tags_with, ->(tag) { kept.tag_counts_on(:tags).where('tags.name ILIKE ?', "%#{tag}%") }

  def clone(user_id)
    dup.tap do |link|
      link.user_id = user_id
      link.due_date = nil
      link.created_at = nil
    end
  end

  private

  def set_default_due_date
    self.due_date = user.summary_setting&.default_due_days&.days&.from_now&.to_date
  end
end
