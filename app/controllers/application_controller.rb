# frozen_string_literal: true

class ApplicationController < ActionController::Base
  include Pagy::Backend

  rescue_from ActiveRecord::RecordNotFound, Pagy::OverflowError, with: :not_found
  rescue_from Exception, with: :internal_server_error if Rails.env.production?

  private

  def not_found
    render 'errors/not_found', status: :not_found
  end

  def internal_server_error
    render 'errors/internal_server_error', status: :internal_server_error
  end
end
