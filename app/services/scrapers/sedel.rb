module Scrapers
  class Sedel
    include Base

    def self.location
      'Sedel'
    end

    def self.locations
      super + ['Luzern', 'LU']
    end

    def self.url
      'https://sedel.ch'
    end

    def program_entries
      page.css('.programm ul > li')
    end

    def event_title(program_entry:)
      program_entry.css('.views-field-title .field-content').content.split('|').map { |content| content.squish }.join(', ')
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      event_start_time(program_entry: program_entry)
    end

    def event_start_time(program_entry:)
      date_string = program_entry.css('.views-field-field-datum-1 time').attr('datetime')
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      "#{self.class.url}#{program_entry.css('a').attr('href').to_s.squish}"
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
