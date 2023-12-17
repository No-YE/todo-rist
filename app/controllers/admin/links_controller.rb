# frozen_string_literal: true

module Admin
  class LinksController < ApplicationController
    def create_initial
      Link.clone_or_create!(link_params[:user_id], link_params[:url])
    end

    private

    def link_params
      params.require(:link).permit(:url, :user_id)
    end
  end
end
