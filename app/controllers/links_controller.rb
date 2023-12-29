# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy]

  MAX_ITEMS = 20

  def index
    @q = current_user.links.completed.order(id: :desc).ransack(params[:q])
    @pagy, @links = pagy(@q.result, items: MAX_ITEMS)
  end

  def create
    @link = Link.clone_or_create!(current_user.id, link_params[:url])
  end

  def destroy
    @link.discard!
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end

  def set_link
    @link = current_user.links.kept.find(params[:id])
  end
end
