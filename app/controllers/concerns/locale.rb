# frozen_string_literal: true

module Locale
  extend ActiveSupport::Concern

  included do
    around_action :switch_locale
  end

  private

  def switch_locale(&)
    locale = current_user&.locale || I18n.default_locale
    I18n.with_locale(locale, &)
  end
end
