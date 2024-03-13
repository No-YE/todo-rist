# frozen_string_literal: true

FactoryBot.define do
  factory :users_summary_setting, class: 'Users::SummarySetting' do
    association :user, factory: :user
    default_due_days { 1 }
  end
end
