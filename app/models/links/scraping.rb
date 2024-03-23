# frozen_string_literal: true

module Links::Scraping
  extend ActiveSupport::Concern

  OPEN_AI_MODEL = 'gpt-3.5-turbo'

  included do
    enum scraping_state: { initial: 0, scraping: 1, completed: 2, failed: 3 }

    after_create_commit :scrap_later, if: :initial?
  end

  def summarize_by_ai
    response = OpenAI.client.chat(
      parameters: {
        model: OPEN_AI_MODEL,
        messages: [
          {
            role: 'user',
            content: summary_prompt,
          },
        ],
        functions: [
          {
            name: 'get_summary',
            description: 'Get 5 lines of summarizing the given link',
            parameters: {
              type: :object,
              properties: {
                korean_summary: {
                  type: :string,
                  description: 'Korean summary of the given link',
                },
              },
              required: %w[korean_summary],
            },
          },
        ],
      },
    )

    response['choices'].each do |choice|
      function_call = choice.dig('message', 'function_call')

      if function_call['name'] == 'get_summary'
        return get_summary(**JSON.parse(function_call['arguments'], symbolize_names: true))
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

  def summary_prompt
    <<~PROMPT
      #{url}
      - 위 링크의 내용을 4~5줄의 완성된 문장으로 요약해 줘.
      - 오직 기술적인 내용만 구체적으로 요약해야 해.
      - 한글로 요약해줘.
    PROMPT
  end

  def get_summary(korean_summary:)
    korean_summary
  end

  def scrap_later
    Links::ScrapingJob.perform_later(self)
  end
end
