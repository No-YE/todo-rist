# frozen_string_literal: true

class Links::RemindNotification < ApplicationNotification
  deliver_by :database, format: :to_database
  deliver_by :email, mailer: 'Links::RemindMailer', if: :email_notification?

  param :links

  def title
    t('.title')
  end

  def link_infos
    params[:link_infos] || params[:links].select(:id, :title, :due_date, :url).as_json
  end

  def links
    params[:links] || params[:link_infos]&.map { |link_info| Link.new(link_info) }
  end

  private

  def to_database
    {
      type: self.class.name,
      params: { link_infos: },
    }
  end

  def email_notification?
    recipient.notification_setting.email?
  end
end
