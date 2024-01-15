# frozen_string_literal: true

class Users::ReminderSetting < Users::ApplicationRecord
  belongs_to :user

  composed_of :schedule,
              class_name: 'Users::Schedule',
              mapping: [%w[schedule_days days], %w[schedule_time time]]

  validates :email, inclusion: { in: [true, false] }
  validates :user, presence: true
  validates :schedule_days, inclusion: { in: DateAndTime::Calculations::DAYS_INTO_WEEK.values }
  validates :schedule_time, presence: true

  before_validation -> { schedule_days.reject!(&:blank?) }

  def self.create_default(user)
    DateAndTime::Calculations::DAYS_INTO_WEEK.keys
    create!(
      user:,
      email: true,
      push: true,
      push_time: Time.zone.parse('9:00'),
    )
  end
end
