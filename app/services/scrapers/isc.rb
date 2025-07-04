module Scrapers
  class Isc
    include Base
    register_scraper

    attr_accessor :current_year, :current_month

    def self.location
      'ISC'
    end

    def self.url
      'https://isc-club.ch/'
    end

    def initialize
      @current_year = Date.current.year
      @current_month = Date.current.month
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
      if month.to_i < current_month
        @current_year += 1
      end
      Time.zone.parse("#{current_year}-#{month}-#{day} 20:00")
    end

    def event_url(program_entry:)
      program_entry.attr('href').to_s
    end

    def event_genres(program_entry:)
      program_entry.css('.event_title_info').content.split(' - ').last.split(',').map(&:squish)
    end
  end
end
