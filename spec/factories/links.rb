# frozen_string_literal: true

FactoryBot.define do
  factory :link do
    user
    sequence(:url) { |n| "https://example.com/#{n}" }

    after(:build) { |link| link.class.skip_callback(:commit, :after, :scrap_later) }
  end
end
