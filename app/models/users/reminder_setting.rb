# frozen_string_literal: true

class Users::ReminderSetting < Users::ApplicationRecord
  belongs_to :user

  composed_of :schedule,
              class_name: 'Users::Schedule',
              mapping: { schedule_days: :days, schedule_time: :time }

  validates :criteria_days,
            presence: true,
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :email, inclusion: { in: [true, false] }
  validates :schedule_days,
            inclusion: { in: DateAndTime::Calculations::DAYS_INTO_WEEK.stringify_keys.keys }
  validates :schedule_time, presence: true

  before_validation -> { schedule_days.compact_blank! }

  after_save_commit :schedule_job,
                    if: -> { saved_change_to_schedule_days? || saved_change_to_schedule_time? }

  # rubocop:disable Rails/SkipsModelValidations
  def schedule_job
    GoodJob::Job.where(id: next_remind_job_id).destroy_all

    next_occurring = schedule.next_occurring
    if next_occurring.present?
      job = Links::RemindJob.set(wait_until: next_occurring).perform_later(self)
      update_column :next_remind_job_id, job.job_id
    else
      update_column :next_remind_job_id, nil
    end
  end
  # rubocop:enable Rails/SkipsModelValidations
end
