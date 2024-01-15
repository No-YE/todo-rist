# frozen_string_literal: true

module Links::Remindable
  extend ActiveSupport::Concern

  included do
    scope :remind_target,
          ->(criteria_days) { where(due_date: ..criteria_days.days.from_now.to_date) }
  end
end
