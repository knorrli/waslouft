module Scrapers
  class Gaskessel
    include Base

    def self.location
      'Gaskessel'
    end

    def self.url
      'https://gaskessel.ch/programm/'
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
      "https://gaskessel.ch/#{program_entry.css('a.previewlink').attr('data-url')}"
    end

    def event_genres(program_entry:)
      program_entry.css('.eventgenre').content.split(',').map(&:squish)
    end
  end
end
