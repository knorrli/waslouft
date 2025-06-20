module Scrapers
  class BadBonn
    include Base
    register_scraper

    def self.location
      'Bad Bonn'
    end

    def self.url
      'https://club.badbonn.ch/program'
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
      time = program_entry.css('.program-time').content.squish

      Time.zone.parse("#{year}-#{month}-#{day}T#{time}")
    end

    def event_url(program_entry:)
      program_entry.css('.program-bands a').attr('href').to_s
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
