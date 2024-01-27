# frozen_string_literal: true

class Links::RemindNotifier < ApplicationNotifier
  deliver_by :email do |config|
    config.mailer = 'LinkMailer'
    config.method = 'remind'
    config.if = -> { params[:email_notification] }
  end

  required_param :remind_infos, :email_notification

  notification_methods do
    def title
      t('.title')
    end

    def description
      t('.description', count: remind_infos.count)
    end

    def remind_infos
      params[:remind_infos]
    end

    def to_partial_path
      'notifications/links/remind_notification'
    end
  end
end
