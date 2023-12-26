# frozen_string_literal: true

module ApplicationHelper
  def relative_time(time)
    if time > 1.day.ago
      time_ago_in_words time
      distance_of_time_in_words(time, Time.current).to_s
    else
      l time.to_date, format: :long
    end
  end
end
