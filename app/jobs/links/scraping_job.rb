# frozen_string_literal: true

class Links::ScrapingJob < ApplicationJob
  queue_as :default

  good_job_control_concurrency_with(
    total_limit: 1,
    key: -> { "Links::ScrapingJob-#{arguments.first.id}" },
  )

  retry_on StandardError, wait: :polynomially_longer, attempts: 3 do |job, error|
    job.arguments.first.update!(scraping_state: :failed)

    logger.error(error)
  end

  def perform(link)
    link.scraping!

    summarizing = Thread.new { summarize_by_openai(link) }
    scraping = Thread.new { MetaInspector.new(link.url) }

    summary = summarizing.value
    page = scraping.value

    link.update!(
      summary:,
      title: page.best_title,
      image_url: page.images.best,
      scraping_state: :completed,
    )
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
      다음 링크의 기술적인 내용을 5줄의 완성된 문장으로 요약해 줘. 오직 기술적인 내용만 구체적으로 요약해야 해. 한글로 요약해 줘.
      #{link.url}"
    PROMPT
  end

  def get_new_summary(first_line:, second_line:, third_line:, fourth_line:, fifth_line:)
    [first_line, second_line, third_line, fourth_line, fifth_line].join("\n")
  end
end
