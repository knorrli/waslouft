module Scrapers
  class MahoganyHall
    include Base

    def self.location
      'Mahogany Hall'
    end

    def self.locations
      super + ['Bern', 'BE']
    end

    def self.url
      'https://www.mahogany.ch/konzerte'
    end

    def program_entries
      page.css('.view-konzerte .views-row')
    end

    def event_title(program_entry:)
      program_entry.css('.views-field-title .field-content').content.squish
    end

    def event_subtitle(program_entry:)
      program_entry.css('.views-field-field-subtitle .field-content').content.squish
    end

    def event_start_date(program_entry:)
      event_start_time(program_entry: program_entry)
    end

    def event_start_time(program_entry:)
      date_string = program_entry.css('.views-field-field-tueroeffnung time').attr('datetime')
      Time.zone.parse(date_string)
    end

    def event_url(program_entry:)
      "https://www.mahogany.ch#{program_entry.css('.views-field-title .field-content a').attr('href').to_s.squish}"
    end

    def event_genres(program_entry:)
      # make sure we don't add full sentences as genre tags
      event_subtitle(program_entry: program_entry).split(/,|\s\-\s|\s[a|u]nd\s|&|\//).map { |content| content.titleize.squish }.reject { |genre| genre.length > 30 }
    end
  end
end
