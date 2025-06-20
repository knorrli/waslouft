module Scrapers
  class Roessli
    include Base
    register_scraper

    def self.location
      'Rössli'
    end

    def self.url
      'https://www.souslepont-roessli.ch/'
    end

    def program_entries
      page.css('.rossli-events .event')
    end

    def event_title(program_entry:)
      program_entry.css('h2').content.squish
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.event-date').attr('datetime')
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      program_entry.css('a').attr('href').to_s
    end

    def event_genres(program_entry:)
      program_entry.css('.event-categories li').map { |category| category.content.squish }
    end
  end
end
