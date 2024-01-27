# frozen_string_literal: true

class NotificationsController < ApplicationController
  before_action :authenticate_user!

  def index
    @notifications = current_user.notifications.order(id: :desc).includes(:event)
    current_user.notifications.unread.mark_as_read
  end
end
