require 'nokolexbor'
require 'open-uri'

module Scrapers
  class BadBonn
    include Base

    def self.call
      new.call
    end

    def initialize
      @location = Location.find_or_create_by(name: 'Bad Bonn', url: 'http://localhost:3000/tests/bad_bonn')
    end

    def program_entries
      page.css('.program-row')
    end

    def event_title(program_entry:)
      program_entry.css('.program-bands a').content.squish
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      year = program_entry.css('.program-year').content.squish
      month = program_entry.css('.program-month').content.squish
      day = program_entry.css('.program-day').content.squish

      Time.zone.parse("#{year}-#{month}-#{day}")
    end

    def event_url(program_entry:)
      program_entry.css('.program-bands a').attr('href').to_s
    end

    def event_tags(program_entry:)
      nil
    end
  end
end
