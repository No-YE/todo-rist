# frozen_string_literal: true

module OpenAI
  def self.client
    @client ||=
      OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :access_token))
  end
end
