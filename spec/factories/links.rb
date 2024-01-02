# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    user
    sequence(:url) { |n| "https://example.com/#{n}" }
  end
end
