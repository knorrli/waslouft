class AdminController < ApplicationController
  def index
    @event_tag_stats = EventTagStatsPresenter.new
  end

  def reload_styles
    json = JSON.parse(File.read('./lib/genres.json'))
    json.each do |style, genres|
      style = Style.find_or_initialize_by(name: style)
      style.update(
        genre_list: genres.map { |g| g.humanize.gsub(/\b('?[a-z])/) { $1.capitalize } }
      )
    end
    redirect_to admin_path
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
