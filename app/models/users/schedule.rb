# frozen_string_literal: true

class Users::Schedule
  attr_reader :days, :time

  def initialize(days, time)
    @days = days
    @time = time
  end

  def next_occurring(current_time = Time.current)
    return unless days.present? && time.present?

    days
      .map { |day| current_time.next_occurring(day.to_sym).change(hour: time.hour, min: time.min) }
      .push(current_time.change(hour: time.hour, min: time.min))
      .filter { |time| time > current_time }
      .min
  end
end
