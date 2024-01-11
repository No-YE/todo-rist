# frozen_string_literal: true

class Users::NotificationSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_notification_setting, only: %i[update]

  def create
    notification_setting = current_user.build_notification_setting(notification_setting_params)
    if notification_setting.save
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = notification_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  def update
    if @notification_setting.update(notification_setting_params)
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = @notification_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  private

  def notification_setting_params
    params.require(:users_notification_setting).permit(:email, :schedule_time, schedule_days: [])
  end

  def set_notification_setting
    @notification_setting = current_user.notification_setting
  end
end
