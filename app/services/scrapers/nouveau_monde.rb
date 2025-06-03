require 'nokolexbor'
require 'open-uri'

module Scrapers
  class NouveauMonde
    include Base

    attr_reader :year

    def initialize
      @location = Location.find_or_create_by(name: 'Nouveau Monde', url: 'http://localhost:3000/tests/nouveau_monde')
    end

    def program_entries
      page.css('.poster[data-tofilter*=concert]')
    end

    def event_title(program_entry:)
      program_entry.css('h4:not(.dateHM)').content.squish
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.date').content.squish
      time_string = program_entry.css('.dateHM').content.squish
      Time.zone.parse("#{date_string} #{time_string}")
    end

    def event_url(program_entry:)
      program_entry.attr('href').to_s
    end
  end
end
