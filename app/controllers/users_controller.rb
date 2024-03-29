# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[me]

  def me
    @user = current_user

    respond_to do |format|
      format.json { render json: @user }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar, :locale)
  end
end
