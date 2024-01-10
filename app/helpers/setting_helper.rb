# frozen_string_literal: true

module SettingHelper
  def setting_language_and_locale_options
    options_for_select(
      { 'English' => 'en', '한국어' => 'ko' },
      current_user.locale,
    )
  end
end
