# frozen_string_literal: true

class ApplicationMailer < ActionMailer::Base
  default from: 'no_reply@todorist.com', to: -> { @recipient.email }

  before_action :set_recipient, :set_notification
  around_action :switch_locale

  layout 'mailer'

  private

  def switch_locale(&)
    locale = @recipient&.locale || I18n.default_locale
    I18n.with_locale(locale, &)
  end

  def set_recipient
    @recipient = params[:recipient]
  end

  def set_notification
    @notification = params[:record]
  end
end
