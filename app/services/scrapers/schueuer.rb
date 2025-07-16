module Scrapers
  class Schueuer
    include Base

    def self.location
      'Schüür'
    end

    def self.locations
      super + ['Luzern', 'LU']
    end

    def self.url
      'https://www.schuur.ch/programm'
    end

    def program_entries
      page.css('.viz-event-list-box')
    end

    def preprocess(program_entry:)
      program_entry.css('.viz-event-genre').content =~ /konzert/i
    end

    def event_title(program_entry:)
      program_entry.css('.viz-event-name').content
    end

    def event_subtitle(program_entry:)
      program_entry.css('.viz-event-headline').content
    end

    def event_start_date(program_entry:)
      event_start_time(program_entry: program_entry)
    end

    def event_start_time(program_entry:)
      date_string = program_entry.css('.viz-event-date').content.squish
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      program_entry.css('a.viz-event-box-details-link').attr('href').to_s.squish
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
