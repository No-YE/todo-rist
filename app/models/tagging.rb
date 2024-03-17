# frozen_string_literal: true

class Tagging < ApplicationRecord
  belongs_to :tag, counter_cache: true
  belongs_to :taggable, polymorphic: true

  validates :tag_id, uniqueness: { scope: %i[taggable_type taggable_id] }
end
