# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def general; end

  private

  def settings_params
    params.require(:settings).permit(:email, :sms)
  end
end
