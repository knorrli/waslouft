class ScrapeEventsJob < ApplicationJob
  queue_as :events

  def perform(scraper_class:)
    scraper_class.safe_constantize.call
  end
end
