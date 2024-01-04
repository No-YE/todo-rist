# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    sequence(:name) { |n| "User #{n}" }
    sequence(:email) { |n| "user#{n}@localhost" }
    provider { 'google_oauth2' }
    sequence(:uid) { |n| "abcd#{n}" }

    trait :admin do
      admin { true }
    end
  end
end
