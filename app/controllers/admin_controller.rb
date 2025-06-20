class AdminController < ApplicationController
  def index
  end

  def reload_styles
    json = JSON.parse(File.read('./lib/genres.json'))
    json.each do |style, genres|
      style = Style.find_or_initialize_by(name: style)
      style.update(genre_list: genres)
    end
    redirect_to admin_path
  end

  def scrape_events
    Scrapers::All.run
  rescue StandardError => e
    debugger
  ensure
    redirect_to admin_path
  end

  def clear_events
    Event.destroy_all
    redirect_to admin_path
  end
end
