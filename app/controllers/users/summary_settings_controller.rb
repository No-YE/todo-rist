# frozen_string_literal: true

class Users::SummarySettingsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_summary_setting, only: %i[update]

  def create
    summary_setting = current_user.build_summary_setting(summary_setting_params)
    if summary_setting.save
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = summary_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  def update
    if @summary_setting.update(summary_setting_params)
      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = @summary_setting.errors.full_messages.first || t('.failure')
    end

    render partial: 'shared/flash'
  end

  private

  def set_summary_setting
    @summary_setting = current_user.summary_setting
  end

  def summary_setting_params
    params
      .require(:users_summary_setting)
      .permit(:default_due_days, :ai_summarizing_enabled, :ai_tagging_enabled)
  end
end
