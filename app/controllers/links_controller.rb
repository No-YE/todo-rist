# frozen_string_literal: true

class LinksController < ApplicationController
  before_action :authenticate_user!

  def index
    @pagy, @records = pagy(current_user.links.order(id: desc))
  end

  def create
    exist_link = Link.with_url(link_params[:url]).completed.order(id: :desc).first

    @link = if exist_link.present?
              exist_link.clone(current_user)
            else
              Link.build_initial(link_params.merge(user: current_user))
            end
  end

  private

  def link_params
    params.require(:link).permit(:url)
  end
end
