# frozen_string_literal: true

module LinkHelper
  def link_until_due_date(due_date)
    distance_in_day = (due_date - Date.current).to_i

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
        left_time = distance_of_time_in_words(due_date.end_of_day, Time.current)
        t('common.some_left', value: left_time)
      end
    end
  end

  def link_sort_text_and_values
    [
      [t('links.index.newest'), 'id desc'],
      [t('links.index.oldest'), 'id asc'],
      [t('links.index.closest_due_date'), 'due_date asc'],
      [t('links.index.farthest_due_date'), 'due_date desc'],
    ]
  end

  def link_others_sort_text_and_values
    [
      [t('links.index.newest'), 'id desc'],
      [t('links.index.oldest'), 'id asc'],
    ]
  end

  def link_current_sort_value
    return nil if @q.sorts.empty?

    [@q.sorts.first.name, @q.sorts.first.dir].join(' ')
  end

  def link_image(url)
    url.presence || asset_path('default_background.png')
  end
end
