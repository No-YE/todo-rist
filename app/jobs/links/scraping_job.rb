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

    summarizing = Thread.new { link.generate_summary }
    crawling = Thread.new { link.crawl }

    summary = summarizing.value
    crawl_result = crawling.value

    link.update!(
      summary:,
      title: crawl_result.title,
      image_url: crawl_result.image_url,
      scraping_state: :completed,
    )
  end
end
