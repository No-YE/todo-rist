# frozen_string_literal: true

module Links::Scraping
  extend ActiveSupport::Concern

  OPEN_AI_MODEL = 'gpt-3.5-turbo'

  included do
    enum scraping_state: { initial: 0, scraping: 1, completed: 2, failed: 3 }

    after_create_commit :scrap_later, if: :initial?
  end

  def summarize_by_open_ai
    response = OpenAI.client.chat(
      parameters: {
        model: OPEN_AI_MODEL,
        messages: [
          {
            role: 'system',
            content: <<~PROMPT,
              다음 사항에 유의해서 사용자가 입력한 링크의 내용을 요약해 줘.
              - 반드시 다섯 문장에서 일곱 문장 사이로 만들어줘.
              - 반드시 한글로 요약해줘.
              - 완전한 문장으로 작성해야 해.
              - 기술적인 내용만 구체적으로 요약해야 해.
            PROMPT
          },
          {
            role: 'user',
            content: url,
          },
        ],
        tools: [
          {
            type: 'function',
            function: {
              name: 'get_summary',
              description: 'Get summarizing the given link',
              parameters: {
                type: 'object',
                properties: {
                  korean_summary: {
                    type: 'string',
                    description: 'Korean summary of the given link',
                  },
                },
                required: %w[korean_summary],
              },
            },
          },
        ],
        tool_choice: {
          type: 'function',
          function: {
            name: 'get_summary',
          },
        },
      },
    )

    tool_calls = response.dig('choices', 0, 'message', 'tool_calls')
    tool_calls.each do |tool_call|
      function = tool_call['function']

      if function['name'] == 'get_summary'
        return get_summary(**JSON.parse(function['arguments'], symbolize_names: true))
      end
    end
  end

  def crawl
    page = MetaInspector.new(url)
    doc = Nokogiri::HTML(page.to_s)
    outline = doc.search('//p[string-length() > 100]').first(5).map(&:text).join(' ')
    Links::CrawlResult.new(title: page.best_title, image_url: page.images.best, outline:)
  end

  def scrap_now
    Links::ScrapingJob.perform_now(self)
  end

  private

  def get_summary(korean_summary:)
    korean_summary
  end

  def scrap_later
    Links::ScrapingJob.perform_later(self)
  end
end
