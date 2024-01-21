# frozen_string_literal: true

class Links::RecordsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_link
  before_action :set_record, only: %i[show edit update destroy]

  def show; end

  def create
    @record = @link.build_record(record_params)

    if @record.save
      flash.now[:notice] = t('.success')
      render_record
    else
      flash.now[:alert] = @record.errors.full_messages.first || t('.failure')
      render partial: 'shared/flash'
    end
  end

  def edit; end

  def update
    if @record.update(record_params)
      flash.now[:notice] = t('.success')
      render_record
    else
      flash.now[:alert] = record.errors.full_messages.first || t('.failure')
      render partial: 'shared/flash'
    end
  end

  def destroy
    if @record.destroy
      flash.now[:notice] = t('.success')
      render_record
    else
      flash.now[:alert] = record.errors.full_messages.first || t('.failure')
      render partial: 'shared/flash'
    end
  end

  private

  def set_link
    @link = current_user.links.find(params[:link_id])
  end

  def set_record
    @record = @link.record || @link.build_record
  end

  def record_params
    params.require(:links_record).permit(:link_id, :content)
  end

  def render_record
    render turbo_stream: turbo_stream.replace(
      [@link, 'record'],
      partial: 'links/records/record',
      locals: { record: @record },
    )
  end
end
