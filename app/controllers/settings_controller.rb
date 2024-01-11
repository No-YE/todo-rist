# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def general; end

  def notification
    @notification_setting =
      current_user.notification_setting || current_user.build_notification_setting
  end
end
