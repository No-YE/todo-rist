# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    user
    title { Faker::Lorem.sentence }
    summary { Faker::Lorem.paragraph(sentence_count: 10) }
    due_date { Faker::Date.forward(days: 30) }
    sequence(:url) { |n| "https://example.com/#{n}" }
  end
end
