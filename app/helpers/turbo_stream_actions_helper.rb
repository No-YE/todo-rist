# frozen_string_literal: true

module TurboStreamActionsHelper
  def show_remote_modal(&)
    turbo_stream_action_tag :show_remote_modal, template: @view_context.capture(&)
  end
end

Turbo::Streams::TagBuilder.prepend(TurboStreamActionsHelper)
