class AdminController < ApplicationController
  def index
  end

  def scrape_events
    Scrapers::All.run
  rescue StandardError => e
    debugger
  ensure
    redirect_to root_path
  end

  def clear_events
    Event.destroy_all
    redirect_to admin_path
  end
end
