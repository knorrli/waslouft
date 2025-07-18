module Scrapers
  class OldKiff
    include Base

    def self.location
      'KIFF'
    end

    def self.locations
      super + ['Aarau', 'AG']
    end

    def self.url
      'https://www.kiff.ch/programm'
    end

    def program_entries
      page.css('.Card-Event')
    end

    def event_title(program_entry:)
      program_entry.css('.Card__Title').children.select { |c| !c.matches?('.Act__country-code') }.map(&:content).join
    end

    def event_subtitle(program_entry:)
      program_entry.css('.Card__Byline').content.squish
    end

    def event_start_date(program_entry:)
      event_start_time(program_entry: program_entry)
    end

    def event_start_time(program_entry:)
      date_string = program_entry.css('.Card__Date time').attr('datetime')
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      "https://www.mahogany.ch#{program_entry.css('.views-field-title .field-content a').attr('href').to_s.squish}"
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
