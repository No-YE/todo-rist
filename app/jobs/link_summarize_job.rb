# frozen_string_literal: true

class LinkSummarizeJob < ApplicationJob
  queue_as :default

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { "LinkSummarizeJob-#{arguments.first.id}" },
  )

  retry_on StandardError, wait: :polynomially_longer, attempts: 3 do |job, error|
    job.arguments.first.update!(state: :failed)

    logger.error(error)
  end

  def perform(link)
    link.update!(state: :summarizing)

    link.update!(summary: summarize_by_openai(link), state: :completed)
  end

  private

  def summarize_by_openai(link)
    result = OpenAIClient.instance.call_function(
      content: generate_prompt(link),
      functions: [
        {
          name: 'get_new_summary',
          description: 'Get 5 lines of summarizing the given link',
          parameters: {
            type: :object,
            properties: {
              first_line: {
                type: :string,
                description: 'The first line of the summary',
              },
              second_line: {
                type: :string,
                description: 'The second line of the summary',
              },
              third_line: {
                type: :string,
                description: 'The third line of the summary',
              },
              fourth_line: {
                type: :string,
                description: 'The fourth line of the summary',
              },
              fifth_line: {
                type: :string,
                description: 'The fifth line of the summary',
              },
            },
            required: %w[first_line second_line third_line fourth_line fifth_line],
          },
        },
      ],
    )

    get_new_summary(**result[0][:arguments])
  end

  # @param [Link] link
  def generate_prompt(link)
    <<~PROMPT
      다음 링크의 기술적인 내용을 5줄로 요약해 줘. 오직 기술적인 내용만 구체적으로 요약해야 해.
      #{link.sanitized_url}"
    PROMPT
  end

  def get_new_summary(first_line:, second_line:, third_line:, fourth_line:, fifth_line:)
    [first_line, second_line, third_line, fourth_line, fifth_line].join("\n")
  end
end
