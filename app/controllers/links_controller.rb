# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy]

  MAX_ITEMS = 20

  def index
    @q = current_user.links.kept.order(id: :desc).ransack(params[:q])
    @pagy, @links = pagy(@q.result, items: MAX_ITEMS)
  end

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      redirect_to links_path
    else
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    @link.discard!
  end

  private

  def link_params
    params.require(:link).permit(:url, :deadline)
  end

  def set_link
    @link = current_user.links.kept.find(params[:id])
  end
end
