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

    summary_setting = Users::SummarySetting.find_by!(user_id: link.user_id)
    crawl_result = link.crawl
    summary = if summary_setting.ai_summarizing_enabled?
                link.summarize_by_ai
              else
                crawl_result.outline
              end

    link.update!(
      summary:,
      title: crawl_result.title,
      image_url: crawl_result.image_url,
      scraping_state: :completed,
    )
  end
end
