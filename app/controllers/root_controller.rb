# frozen_string_literal: true

class RootController < ApplicationController
  def index
    redirect_to links_path and return if user_signed_in?

    @links = Link.kept.completed.order(id: :desc).limit(20)
  end

  def direct_close
    render layout: false
  end

  def tos
    redirect_to Settings.tos.url, allow_other_host: true
  end

  def privacy_policy
    redirect_to Settings.privacy_policy.url, allow_other_host: true
  end
end
