module Scrapers
  class FriSon
    include Base

    def self.location
      'FriSon'
    end

    def self.url
      'https://www.fri-son.ch/fr/programme?f%5B0%5D=category%3A1'
    end

    def program_entries
      page.css('.view-events .node--type-event')
    end

    def event_title(program_entry:)
      program_entry.css('.performers.main .performer').children.select(&:text?).map { |node| node.text.squish }.compact_blank.join(', ')
    end

    def event_subtitle(program_entry:)
      program_entry.css('.performers.standard .performer').children.select(&:text?).map { |node| node.text.squish }.compact_blank.join(', ')
    end

    def event_start_date(program_entry:)
      date_string = program_entry.css('.field.field--name-field-date .datetime').attr('datetime')
      Time.zone.parse(date_string)
    end

    def event_start_time(program_entry:)
      time_string = program_entry.css('.field.field--name-field-time-doors').content.squish
      Time.zone.parse("#{event_start_date(program_entry: program_entry).to_date.iso8601}, #{time_string}")
    end

    def event_url(program_entry:)
      "https://www.fri-son.ch#{program_entry.at_css('a').attr('href').to_s.squish}"
    end

    def event_genres(program_entry:)
      program_entry.css('.genre-wrapper .field__item').map { |tag| tag.content.squish }
    end
  end
end
