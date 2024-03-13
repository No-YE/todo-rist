# frozen_string_literal: true

class Users::SummarySetting < Users::ApplicationRecord
  belongs_to :user

  validates :default_due_days, numericality: { only_integer: true, greater_than_or_equal_to: 0 }, allow_nil: true
end
