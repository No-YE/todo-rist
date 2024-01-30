# frozen_string_literal: true

FactoryBot.define do
  factory :users_reminder_setting, class: 'Users::ReminderSetting' do
    association :user, factory: :user
    criteria_days { 1 }
    email { true }
    schedule_days { %w[monday tuesday wednesday thursday friday] }
    schedule_time { '9am' }
  end
end
