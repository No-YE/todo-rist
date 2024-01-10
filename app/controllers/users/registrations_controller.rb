# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  def update
    if current_user.update(user_params)
      if current_user.saved_change_to_locale?
        I18n.locale = current_user.locale
        redirect_to general_settings_path, notice: t('.success')
        return
      end

      flash.now[:notice] = t('.success')
    else
      flash.now[:alert] = current_user.errors.full_messages.first || t('.failure')
      render partial: 'shared/flash'
    end
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  private

  def user_params
    params.require(:user).permit(:locale, :name, :avatar)
  end
end
