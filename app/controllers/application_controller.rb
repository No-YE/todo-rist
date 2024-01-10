# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend
  include Locale

  layout -> { nil if turbo_frame_request? }

  protect_from_forgery unless: -> { request.format.json? }

  rescue_from ActiveRecord::RecordNotFound, Pagy::OverflowError, with: :not_found
  rescue_from Exception, with: :internal_server_error if Rails.env.production?

  private

  def authenticate_user!
    if user_signed_in?
      super
    else
      flash.now[:alert] = t('devise.failure.unauthenticated')

      respond_to do |format|
        format.html { redirect_to root_path, alert: flash.now[:alert] }
        format.turbo_stream { render partial: 'shared/flash' }
        format.json { render json: { error: flash.now[:alert] }, status: :unauthorized }
      end
    end
  end

  def not_found
    render 'errors/not_found', status: :not_found
  end

  def internal_server_error
    render 'errors/internal_server_error', status: :internal_server_error
  end
end
