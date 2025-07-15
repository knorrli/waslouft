module Scrapers
  class Dachstock
    include Base

    def self.location
      'Dachstock'
    end

    def self.locations
      super + ['Reitschule', 'Bern', 'BE']
    end

    def self.url
      'https://www.dachstock.ch/events'
    end

    def program_entries
      page.css('.event-list .event-teaser')
    end

    def event_title(program_entry:)
      program_entry.css('.event-teaser-info .artist-name').map(&:content).join(', ')
    end

    def event_subtitle(program_entry:)
      program_entry.css('.event-teaser-info .event-title').content.squish
    end

    def event_start_date(program_entry:)
      event_start_time(program_entry: program_entry)
    end

    def event_start_time(program_entry:)
      date_string = program_entry.css('.event-date').content.squish
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      "https://www.dachstock.ch#{program_entry.css('.event-teaser-info a.event-teaser-bottom').attr('href').to_s.squish}"
    end

    def event_genres(program_entry:)
      program_entry.css('.event-teaser-info .event-teaser-tags .tag').map { |tag| tag.content.squish }
    end
  end
end
