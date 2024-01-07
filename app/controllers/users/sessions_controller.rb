# frozen_string_literal: true

class Users::SessionsController < Devise::SessionsController
  before_action :direct_close, only: %i[new], if: :chrome_extension?
  skip_before_action :require_no_authentication, if: :chrome_extension?
  helper_method :chrome_extension?

  private

  def direct_close
    redirect_to direct_close_path if user_signed_in?
  end

  def chrome_extension?
    params[:chrome_extension] == 'true'
  end
end
