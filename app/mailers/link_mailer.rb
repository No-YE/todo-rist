# frozen_string_literal: true

class LinkMailer < ApplicationMailer
  helper :link

  def remind
    @recipient = params[:recipient]
    @links = params[:links]
    mail(subject: @notification.title)
  end
end
