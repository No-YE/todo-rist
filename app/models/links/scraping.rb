# frozen_string_literal: true

module Links::Scraping
  extend ActiveSupport::Concern

  included do
    enum scraping_state: { initial: 0, scraping: 1, completed: 2, failed: 3 }

    after_create_commit :scrap_later, if: :initial?
  end

  def summarize_by_open_ai
    response = OpenAI.client.chat(
      parameters: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: <<~PROMPT,
              다음 순서로 사용자가 입력한 링크의 내용을 요약해.
              1. 사용자가 입력한 링크의 내용을 이해해.
              2. 사용자가 입력한 링크의 내용을 요약해.
              3. 요약한 내용을 가지고 get_summary 함수를 호출해.

              요약할 때는 다음 사항을 고려해야해.
              - 미사여구는 빼고 핵심적인 내용만 요약해.
              - 5문장에서 7문장 사이로 요약해.
              - 한글로 요약해.
              - 높임말을 사용해.
              - "~다" 형식으로 만들어.
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

  def tag_by_open_ai(target_tags)
    response = OpenAI.client.chat(
      parameters: {
        model: 'gpt-4',
        messages: [
          {
            role: 'system',
            content: <<~PROMPT,
              다음 순서로 알맞은 태그를 추천해.
              1. 먼저 주어진 링크의 내용을 이해해.
              2. 주어진 태그 중에서 링크의 내용과 관련 있는 것을 0개에서 5개 사이로 선택해. 링크 내용에 없는 것은 선택하면 안돼.
              3. 선택한 태그를 가지고 get_tags 함수를 호출해.
            PROMPT
          },
          {
            role: 'user',
            content: <<~PROMPT,
              링크: #{url}
              태그: #{target_tags.join(', ')}
            PROMPT
          },
        ],
        tools: [
          {
            type: 'function',
            function: {
              name: 'get_tags',
              description: 'Get suggested tags for the given link',
              parameters: {
                type: 'object',
                properties: {
                  tags: {
                    type: 'array',
                    items: {
                      type: 'string',
                    },
                    description: 'Suggested tags for the given link',
                  },
                },
              },
            },
          },
        ],
        tool_choice: {
          type: 'function',
          function: {
            name: 'get_tags',
          },
        },
      },
    )

    tool_calls = response.dig('choices', 0, 'message', 'tool_calls')
    tool_calls.each do |tool_call|
      function = tool_call['function']

      return get_tags(**JSON.parse(function['arguments'], symbolize_names: true)) if function['name'] == 'get_tags'
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

  def get_tags(tags:)
    tags.compact_blank
  end

  def scrap_later
    Links::ScrapingJob.perform_later(self)
  end
end
