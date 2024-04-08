# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  MAX_ITEMS = 20

  def index
    @pagy, @notifications = pagy(
      current_user.notifications.order(id: :desc).includes(:event),
      items: MAX_ITEMS,
    )
    @notifications.unread.mark_as_read
  end
end
