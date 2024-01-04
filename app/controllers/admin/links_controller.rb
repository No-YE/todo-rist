# frozen_string_literal: true

class Admin::LinksController < Admin::ApplicationController
  def create_initial
    Link.create!(link_params)
  end

  private

  def link_params
    params.require(:link).permit(:url, :user_id, :due_date)
  end
end
