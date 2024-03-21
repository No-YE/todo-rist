# frozen_string_literal: true

class Links::TagsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tag, only: %i[edit update destroy]

  def index
    tags = Links::Tag.with_user(current_user).by_name(params[:q]).limit(10).pluck(:name)
    tags.unshift(params[:q]) if tags.exclude?(params[:q])

    respond_to do |format|
      format.json do
        render json: tags.map { |tag| { value: tag, text: tag } }
      end
    end
  end

  def new
    @tag = Links::Tag.new
  end

  def edit; end

  def create
    @tag = Links::Tag.new(tag_params.merge(user: current_user))
    if @tag.save
      redirect_to tag_settings_path, notice: t('.success')
    else
      render :new
    end
  end

  def update
    if @tag.update(tag_params)
      redirect_to tag_settings_path, notice: t('.success')
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @tag.destroy
      redirect_to tag_settings_path, notice: t('.success')
    else
      flash.now[:alert] = @tag.errors.full_messages.first || t('.failure')
      render partial: 'shared/flash'
    end
  end

  private

  def tag_params
    params.require(:links_tag).permit(:name)
  end

  def set_tag
    @tag = Links::Tag.with_user(current_user).find(params[:id])
  end
end
