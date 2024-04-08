# frozen_string_literal: true

module Discordrb
  def self.charles_test_bot
    @charles_test_bot ||= Discordrb::Bot.new(
      token: Rails.application.credentials.dig(:discord, :charles_test, :token),
    )
  end
end
