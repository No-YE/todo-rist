# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @records = pagy(current_user.links.order(id: desc))
  end

  def create
    @link = Link.clone_or_create!(current_user.id, link_params[:url])
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
