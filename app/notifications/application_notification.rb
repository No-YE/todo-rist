# frozen_string_literal: true

class ApplicationNotification < Noticed::Base
  def to_partial_path
    "notifications/#{self.class.name.underscore}"
  end
end
