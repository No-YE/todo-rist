# frozen_string_literal: true

module Link::Scraping
  extend ActiveSupport::Concern

  included do
    enum scraping_state: { initial: 0, scraping: 1, completed: 2, failed: 3 }

    after_create_commit :scrap_later, if: :initial?
  end

  def scrap_now
    LinkScrapingJob.perform_now(self)
  end

  private

  def scrap_later
    LinkScrapingJob.perform_later(self)
  end
end
