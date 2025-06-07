
module Scrapers
  class Gaskessel
    include Base

    def initialize
      @location = Location.find_or_create_by(name: 'Gaskessel', url: 'http://localhost:3000/tests/gaskessel')
    end

    def program_entries
      page.css('.eventpreview')
    end

    def event_title(program_entry:)
      program_entry.css('.eventname').content.squish
    end

    def event_subtitle(program_entry:)
      program_entry.css('.subtitle').content.squish
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.eventdatum').content.squish

      /(?<day>\d{1,2})?\.(?<month>\d{1,2})?\.(?<year>\d+)/ =~ date_string
      Time.zone.parse("20#{year}-#{month}-#{day}")
    end

    def event_url(program_entry:)
      program_entry.css('a.previewlink').attr('href').to_s
    end

    def event_tags(program_entry:)
      program_entry.css('.eventgenre').content.split(',').map(&:squish)
    end
  end
end
