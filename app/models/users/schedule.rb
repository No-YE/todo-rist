# frozen_string_literal: true

class Users::Schedule
  attr_reader :days, :time

  def initialize(days, time)
    @days = days
    @time = time
  end
end
