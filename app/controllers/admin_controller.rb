class AdminController < ApplicationController
  def index
    @event_tag_stats = EventTagStatsPresenter.new
  end

  def scrape_events
    Scrapers::All.run
  rescue StandardError => e
  ensure
    redirect_to admin_path
  end

  def clear_events
    Event.destroy_all
    redirect_to admin_path
  end
end
