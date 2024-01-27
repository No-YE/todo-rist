# frozen_string_literal: true

# Preview all emails at http://localhost:3000/rails/mailers/link
class LinkPreview < ActionMailer::Preview
  def remind
    recipient = FactoryBot.build_stubbed(:user)
    remind_infos = FactoryBot.build_stubbed_list(:link, 3).map(&:to_remind_info)
    notifier = FactoryBot.build_stubbed(:link_remind_notifier, params: { remind_infos: })
    notification = Links::RemindNotifier::Notification.new(recipient:, event: notifier)

    LinkMailer.with(notification:, recipient:, remind_infos:).remind
  end
end
