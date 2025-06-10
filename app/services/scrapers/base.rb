require 'nokolexbor'
require 'open-uri'

module Scrapers
  module Base
    extend ActiveSupport::Concern
    attr_reader :location

    class_methods do
      def call
        new.call
      end
    end

    def call
      program_entries.each do |program_entry|
        next unless preprocess(program_entry: program_entry)

        event = location.events.find_or_initialize_by(
          title: event_title(program_entry: program_entry).squish,
          start_date: event_start_date(program_entry: program_entry)
        )

        event.update(
          url: event_url(program_entry: program_entry)&.squish,
          subtitle: event_subtitle(program_entry: program_entry)&.squish,
          genre_list: event_tags(program_entry: program_entry),
          location_list: event.location.name
        )
      rescue StandardError => e
        debugger
        Rails.logger.error(e)
      end
    end

    def page
      @page ||= begin
                  html_content = URI.open(location.url).read
                  program_page = Nokolexbor::HTML(html_content)
                end
    end

    # skip iteration by returning false when necessary
    def preprocess(program_entry:)
      true
    end

    def program_entries
      raise 'implement in subclass'
    end

    def event_title(program_entry:)
      raise 'implement in subclass'
    end

    def event_subtitle(program_entry:)
      nil
    end

    def event_start_date(program_entry:)
      raise 'implement in subclass'
    end

    def event_url(program_entry:)
      raise 'implement in subclass'
    end

    def event_tags(program_entry:)
      []
    end
  end
end
