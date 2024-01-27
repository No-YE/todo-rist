# frozen_string_literal: true

module Links::Remindable
  extend ActiveSupport::Concern

  included do
    scope :remind_target, ->(criteria_days) do
      unread.where(due_date: ..criteria_days.days.from_now.to_date).order(due_date: :asc)
    end
  end

  def must_read?
    unread? && due_date.present?
  end

  def to_remind_info
    Links::RemindInfo.new(id:, title:, due_date:, url:, created_at:)
  end
end
