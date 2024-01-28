# frozen_string_literal: true

FactoryBot.define do
  factory :links_record, class: 'Links::Record' do
    association :link, factory: :link
    content { Faker::Lorem.paragraph(sentence_count: 10) }
  end
end
