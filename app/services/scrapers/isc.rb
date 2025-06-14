module Scrapers
  class Isc
    include Base
    register_scraper

    attr_accessor :current_year

    def initialize
      @location = Location.find_or_create_by(name: 'ISC', url: 'https://isc-club.ch/')
      @current_year = Date.current.year
    end

    def preprocess(program_entry:)
      event_type = program_entry.css('.event_title_info').content.split(' - ').first&.squish
      return true if event_type == 'Konzert'

      false
    end

    def program_entries
      page.css('a.event_preview')
    end

    def event_title(program_entry:)
      program_entry.css('.event_title_title').content
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.event_title_date').content.squish
      /(?<day>\d{1,2})?\.(?<month>\d{1,2})?\./ =~ date_string
      Time.zone.parse("#{current_year}-#{month}-#{day}")
    end

    def event_url(program_entry:)
      program_entry.attr('href').to_s
    end

    def event_tags(program_entry:)
      program_entry.css('.event_title_info').content.split(' - ').last.split(',').map(&:squish)
    end
  end
end
