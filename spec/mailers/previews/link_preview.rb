# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/link
class LinkPreview < ActionMailer::Preview
  def remind
    recipient = FactoryBot.build_stubbed(:user)
    links = FactoryBot.build_stubbed_list(:link, 3)
    record = Links::RemindNotification.new(recipient:, links:)
    LinkMailer.with(recipient:, links:, record:).remind
  end
end
