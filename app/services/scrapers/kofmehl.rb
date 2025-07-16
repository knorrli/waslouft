module Scrapers
  class Kofmehl
    include Base

    attr_reader :current_year, :last_event_date

    def self.location
      'Kofmehl'
    end

    def self.locations
      super + ['Solothurn', 'SO']
    end

    def self.url
      'https://kofmehl.net/'
    end

    def initialize
      @current_year = Date.current.year
    end

    def program_entries
      page.css('.events .events__element')
    end

    def preprocess(program_entry:)
      if last_event_date && last_event_date > event_start_date(program_entry: program_entry)
        @current_year += 1
      end
      true
    end


    def event_title(program_entry:)
      program_entry.css('.events__title').content
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.events__date').content.squish
      @last_event_date = Time.zone.parse("#{date_string}.#{current_year}")
    end

    def event_start_time(program_entry:)
      nil
    end

    def event_url(program_entry:)
      program_entry.css('a.events__link').attr('href').to_s.squish
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
