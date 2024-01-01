# frozen_string_literal: true

class LinksController < ApplicationController
  include Searchable

  before_action :authenticate_user!
  before_action :set_link, only: %i[destroy read unread]

  MAX_ITEMS = 20

  def index
    @q = current_user.links.kept.ransack(search_params)
    @q.sorts = 'id desc' if @q.sorts.empty?
    @pagy, @links = pagy(@q.result, items: MAX_ITEMS)
  end

  def others
    links_with_distinct_url = Link.select('DISTINCT ON (url) *')
                                  .kept
                                  .where.not(user_id: current_user.id)

    @q = Link.from(links_with_distinct_url, :links).ransack(search_params)
    @q.sorts = 'id desc' if @q.sorts.empty?
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

  def read
    @link.read!
  end

  def unread
    @link.unread!
  end

  def clone
    cloned_link = Link.kept.find(params[:id]).clone(current_user.id)

    if cloned_link.save
      flash.now[:notice] = t('.clone.success')
    else
      flash.now[:alert] = cloned_link.errors.full_messages.first || t('.clone.failure')
    end

    render partial: 'shared/flash'
  end

  private

  def link_params
    params.require(:link).permit(:url, :deadline)
  end

  def set_link
    @link = current_user.links.kept.find(params[:id])
  end
end
