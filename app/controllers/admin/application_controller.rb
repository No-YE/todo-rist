# frozen_string_literal: true

class Admin::ApplicationController < ApplicationController
  before_action :authenticate_user!
  before_action :authenticate_admin!

  private

  def authenticate_admin!
    render 'errors/not_found', status: :not_found unless current_user.admin?
  end
end
