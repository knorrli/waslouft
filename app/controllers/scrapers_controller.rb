class ScrapersController < ApplicationController
  def run
    Scrapers::All.run
  rescue StandardError => e
    debugger
  ensure
    redirect_to root_path
  end

  def clear
    Event.destroy_all
    redirect_to root_path
  end
end
