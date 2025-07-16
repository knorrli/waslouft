module Scrapers
  class Boeroem
    include Base

    def self.location
      'Böröm'
    end

    def self.locations
      super + ['Oberentfelden', 'Aarau', 'AG']
    end

    def self.url
      'https://boeroem.ch/'
    end

    def program_entries
      page.css('.veranstaltung')
    end

    def event_title(program_entry:)
      program_entry.css('h2.elementor-heading-title').content.squish
    end

    def event_subtitle(program_entry:)
      program_entry.css('.event-liste-untertitel h3.elementor-heading-title').content.squish
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.event-liste-datum').content.squish
      Time.zone.parse(date_string)
    end

    def event_start_time(program_entry:)
      nil
    end

    def event_url(program_entry:)
      program_entry.css('.event-liste-datum a').attr('href').to_s.squish
    end

    def event_genres(program_entry:)
      nil
    end
  end
end
