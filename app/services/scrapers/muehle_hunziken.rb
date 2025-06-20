module Scrapers
  class MuehleHunziken
    include Base
    register_scraper

    def self.active?
      false
    end

    def self.location
      'Mühle Hunziken'
    end

    def self.url
      'https://muehlehunziken.ch/'
    end

    attr_reader :year

    def initialize
      @year = Date.current.year
    end

    def program_entries
      page.css('#schedule li')
    end

    def preprocess(program_entry:)
      next_year = program_entry.css('.yearTitle').content

      if next_year.present?
        @year = next_year
        return false
      end

      true
    end

    def event_title(program_entry:)
      program_entry.css('.text-clink h2').content.squish
    end

    def event_subtitle(program_entry:)
      program_entry.css('.text-clink > div + div.font-heading').content&.squish
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('div > span + span').content.squish
      /(?<day>\d{1,2})?\.(?<month>\d{1,2})?\./ =~ date_string
      Time.zone.parse("#{year}-#{month}-#{day}")
    end

    def event_url(program_entry:)
      program_entry.css('a.customLink').attr('href').to_s
    end

    def event_genres(program_entry:)
      tags = program_entry.css('div > h2 + div .flag').content.squish
    end
  end
end
