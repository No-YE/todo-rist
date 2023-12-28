# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  MAX_ITEMS = 20

  def index
    @pagy, @links = pagy(current_user.links.completed.order(id: :desc), items: MAX_ITEMS)
  end

  def create
    @link = Link.clone_or_create!(current_user.id, link_params[:url])
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
