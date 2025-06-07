
module Scrapers
  class Cafete
    include Base

    def initialize
      @location = Location.find_or_create_by(name: 'Cafete', url: 'http://localhost:3000/tests/cafete')
    end

    def program_entries
      page.css('.event')
    end

    def event_title(program_entry:)
      program_entry.css('.title').content.squish
    end

    def event_subtitle(program_entry:)
      program_entry.css('.acts').content.squish
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.date').content.squish

      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      nil
    end

    def event_tags(program_entry:)
      program_entry.css('.style').content.gsub(/Style:/, '').split('/').map(&:squish)
    end
  end
end
