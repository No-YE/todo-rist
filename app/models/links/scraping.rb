# frozen_string_literal: true

module Links::Scraping
  extend ActiveSupport::Concern

  included do
    enum scraping_state: { initial: 0, scraping: 1, completed: 2, failed: 3 }

    after_create_commit :scrap_later, if: :initial?
  end

  def scrap_now
    Links::ScrapingJob.perform_now(self)
  end

  private

  def scrap_later
    Links::ScrapingJob.perform_later(self)
  end
end
