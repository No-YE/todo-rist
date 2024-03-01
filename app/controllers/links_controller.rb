# frozen_string_literal: true

class LinksController < ApplicationController
  include Searchable

  before_action :authenticate_user!, except: %i[show]
  before_action :set_link, only: %i[edit update destroy read unread]

  MAX_ITEMS = 20

  def index
    @q = current_user.links.kept.ransack(search_params)
    @q.sorts = 'id desc' if @q.sorts.empty?
    @pagy, @links = pagy(@q.result, items: MAX_ITEMS)

    respond_to do |format|
      format.html
      format.turbo_stream { render turbo_stream: turbo_stream.replace('links', partial: 'links') }
      format.json { render json: @links }
    end
  end

  def others
    links_with_distinct_url = Link.select('DISTINCT ON (url) *')
                                  .kept
                                  .where.not(user_id: current_user.id)

    @q = Link.from(links_with_distinct_url, :links).ransack(search_params)
    @q.sorts = 'id desc' if @q.sorts.empty?
    @pagy, @links = pagy(@q.result, items: MAX_ITEMS)
  end

  def show
    @link = Link.kept.find(params[:id])
  end

  def new
    @link = current_user.links.build
  end

  def create
    @link = current_user.links.build(link_params)

    if @link.save
      respond_to do |format|
        format.json { render json: @link }
        format.any do
          flash[:notice] = t('.success')
          redirect_to link_path(@link)
        end
      end
    else
      respond_to do |format|
        format.json { render json: @link.errors.full_messages, status: :unprocessable_entity }
        format.any do
          flash.now[:alert] = @link.errors.full_messages.first || t('.failure')
          render :new, status: :unprocessable_entity
        end
      end
    end
  end

  def edit; end

  def update
    if @link.update(update_link_params)
      flash[:notice] = t('.success')
      redirect_to link_path(@link)
    else
      flash.now[:alert] = @link.errors.full_messages.first || t('.failure')
      render :edit, status: :unprocessable_entity
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

  def tags
    @tags = Link.tags_with(params[:q])
                .order(taggings_count: :desc)
                .limit(10)
                .pluck(:name)
    @tags.unshift(params[:q]) if @tags.exclude?(params[:q])

    respond_to do |format|
      format.json do
        render json: @tags.map { |tag| { value: tag, text: tag } }
      end
    end
  end

  private

  def link_params
    params.require(:link).permit(:url, :due_date, tag_list: [])
  end

  def update_link_params
    params.require(:link).permit(:due_date, tag_list: [])
  end

  def set_link
    @link = current_user.links.kept.find(params[:id])
  end
end
