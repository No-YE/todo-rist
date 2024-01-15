# frozen_string_literal: true

class Links::RemindJob < ApplicationJob
  queue_as :default

  def perform(reminder_setting)
    links = Link.remind_target(reminder_setting.criteria_days)
    Links::RemindNotification.with(links:, reminder_setting:).deliver(reminder_setting.user)

    reminder_setting.schedule_job
  end
end
