# frozen_string_literal: true

module LinkHelper
  def link_relative_created_at(link)
    if link.created_at > 1.day.ago
      time_ago_in_words link.created_at
      t('common.some_ago', value: distance_of_time_in_words(link.created_at, Time.current))
    else
      l link.created_at.to_date, format: :long
    end
  end

  def link_until_due_date(link)
    distance_in_day = (link.due_date - Date.current).to_i

    classes = case distance_in_day
              when ..0
                'text-red-700 font-semibold'
              when 1..3
                'text-yellow-800 font-medium'
              when 4..7
                'text-blue-700 font-normal'
              else
                'text-green-700 font-normal'
              end

    content_tag :span, class: classes do
      if distance_in_day.negative?
        t('common.overdue')
      else
        t('common.some_left', value: distance_of_time_in_words(link.due_date.end_of_day, Time.current))
      end
    end
  end
end
