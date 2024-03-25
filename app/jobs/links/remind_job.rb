# frozen_string_literal: true

class Links::RemindJob < ApplicationJob
  queue_as :default

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { "Links::RemindJob-#{arguments.first.id}" },
  )

  def perform(reminder_setting)
    remind_infos = Link.kept.remind_target(reminder_setting.criteria_days).map(&:to_remind_info)
    Links::RemindNotifier
      .with(remind_infos:, email_notification: reminder_setting.email?)
      .deliver(reminder_setting.user)

    reminder_setting.schedule_job
  end
end
