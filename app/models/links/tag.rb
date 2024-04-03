# frozen_string_literal: true

class Links::Tag < Tag
  has_many :links, through: :taggings, source: :taggable, source_type: 'Link'

  scope :by_name, ->(name) { where('name ILIKE ?', "%#{name}%") }
  scope :with_user, ->(user) { where(user:) }
  scope :with_user_id, ->(user_id) { where(user_id:) }
end
