# frozen_string_literal: true

FactoryBot.define do
  factory :link_remind_notifier, class: 'Links::RemindNotifier' do
    params { {} }
  end
end
