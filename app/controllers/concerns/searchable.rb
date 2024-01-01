# frozen_string_literal: true

module Searchable
  extend ActiveSupport::Concern

  private

  def search_params
    params[:q] = session[search_key] if params[:q].nil?
    session[search_key] = params[:q] if params[:q].present?

    params[:q]
  end

  def search_key
    :"#{controller_name}_#{action_name}_search"
  end
end
