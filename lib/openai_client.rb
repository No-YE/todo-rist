# frozen_string_literal: true

class OpenAIClient
  include Singleton

  MODEL = 'gpt-3.5-turbo'

  def initialize
    @client = OpenAI::Client.new(access_token: Rails.application.credentials.dig(:openai, :access_token))
  end

  def call_function(content:, functions:)
    response = @client.chat(
      parameters: {
        model: MODEL,
        messages: [
          {
            role: 'user',
            content:,
          },
        ],
        functions:,
      },
    )

    response['choices'].map do |choice|
      function_call = choice.dig('message', 'function_call')

      {
        name: function_call['name'],
        arguments: JSON.parse(function_call['arguments'], symbolize_names: true),
      }
    end
  end
end
