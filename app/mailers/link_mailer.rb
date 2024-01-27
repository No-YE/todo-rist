# frozen_string_literal: true

class LinkMailer < ApplicationMailer
  helper :link

  def remind
    @notification = params[:notification]
    @recipient = params[:recipient]
    @remind_infos = params[:remind_infos]
    mail(subject: @notification.title)
  end
end
