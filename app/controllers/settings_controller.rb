# frozen_string_literal: true

class SettingsController < ApplicationController
  before_action :authenticate_user!

  def general; end

  def summary
    @summary_setting = current_user.summary_setting || current_user.build_summary_setting
  end

  def notification
    @reminder_setting = current_user.reminder_setting || current_user.build_reminder_setting
  end

  def tag
    @tags = Links::Tag.with_user(current_user).order(id: :desc)
    @tag = Links::Tag.new
  end
end
