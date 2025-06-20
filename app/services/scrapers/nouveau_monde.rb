module Scrapers
  class NouveauMonde
    include Base
    register_scraper

    def self.location
      'Nouveau Monde'
    end

    def self.url
      'https://www.nouveaumonde.ch/agenda/'
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
