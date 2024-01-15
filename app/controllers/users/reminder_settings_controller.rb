# frozen_string_literal: true

class Users::ReminderSettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_reminder_setting, only: %i[update]

  def create
    reminder_setting = current_user.build_reminder_setting(reminder_setting_params)
    if reminder_setting.save
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = reminder_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  def update
    if @reminder_setting.update(reminder_setting_params)
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = @reminder_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  private

  def reminder_setting_params
    params.require(:users_reminder_setting).permit(:email, :schedule_time, schedule_days: [])
  end

  def set_reminder_setting
    @reminder_setting = current_user.reminder_setting
  end
end
