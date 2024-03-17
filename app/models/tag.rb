# frozen_string_literal: true

class Tag < ApplicationRecord
  belongs_to :user
  has_many :taggings, dependent: :destroy, counter_cache: true

  validates :name, presence: true, allow_blank: false, uniqueness: { scope: %i[user_id type] }

  def self.ransackable_attributes(_auth_object = nil)
    %w[name type]
  end
end
