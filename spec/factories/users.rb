# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@localhost" }
    provider { 'google_oauth2' }
    uid { 'abcd' }
  end
end
