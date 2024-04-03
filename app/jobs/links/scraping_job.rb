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
                link.summarize_by_open_ai
              else
                crawl_result.outline
              end

    link.assign_attributes(
      summary:,
      title: crawl_result.title,
      image_url: crawl_result.image_url,
      scraping_state: :completed,
    )

    if summary_setting.ai_tagging_enabled? && link.tag_names.empty?
      target_tags = Links::Tag.with_user_id(link.user_id).pluck(:name)
      link.tag_names = link.tag_by_open_ai(target_tags)
    end

    link.save!
  end
end
