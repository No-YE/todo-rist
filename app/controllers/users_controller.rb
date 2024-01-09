# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[me]

  def update
    respond_to do |format|
      format.turbo_stream do
        if current_user.update(user_params)
          flash.now[:notice] = t('.success')
        else
          flash.now[:alert] = current_user.errors.full_messages.first || t('.failure')
          render partial: 'shared/flash'
        end
      end
    end
  end

  def me
    @user = current_user

    respond_to do |format|
      format.json { render json: @user }
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :avatar)
  end
end
