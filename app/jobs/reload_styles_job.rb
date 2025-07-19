class ReloadStylesJob < ApplicationJob
  queue_as :default

  def perform(*args)
    json = JSON.parse(File.read('./lib/genres.json'))
    json.each do |style, genres|
      style = Style.find_or_initialize_by(name: style)
      style.update(
        genre_list: genres.map { |g| g.humanize.gsub(/\b('?[a-z])/) { $1.capitalize } }
      )
    end
  end
end
