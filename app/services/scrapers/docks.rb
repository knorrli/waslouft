module Scrapers
  class Docks
    include Base

    def self.location
      'Docks'
    end

    def self.locations
      super + ['Lausanne', 'VD']
    end

    def self.url
      'https://www.docks.ch/programme'
    end

    def program_entries
      page.css('.programme-container .mix.concerts')
    end

    def event_title(program_entry:)
      program_entry.css('.programme-item-title').content.split('|').map { |content| content.squish }.join(', ')
    end

    def event_subtitle(program_entry:)
      program_entry.css('.programme-item-subtitle').content.split('+').map { |content| content.squish }.compact_blank.join(', ')
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.programme-item-date').content[/\d{1,2}\.\d{1,2}\.\d{4}/]
      Time.zone.parse(date_string)
    end

    def event_start_time(program_entry:)
      nil
    end

    def event_url(program_entry:)
      program_entry.css('a').attr('href').to_s.squish
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
