require 'nokolexbor'
require 'open-uri'

module Scrapers
  module Base
    extend ActiveSupport::Concern

    included do
      register_scraper
    end

    class_methods do
      def call
        new.call if active?
      end

      def register_scraper
        All.scrapers[name.demodulize] = self
      end

      def location
        raise 'implement in subclass'
      end

      def url
        raise 'implement in subclass'
      end

      def active?
        true
      end
    end

    def call
      program_entries.each do |program_entry|
        next unless preprocess(program_entry: program_entry)

        event = Event.tagged_with(location, on: :locations).find_or_initialize_by(
          start_date: event_start_date(program_entry: program_entry)
        )

        genres = event_genres(program_entry: program_entry)
        event.update(
          title: event_title(program_entry: program_entry).squish,
          subtitle: event_subtitle(program_entry: program_entry)&.squish,
          url: event_url(program_entry: program_entry)&.squish,
          start_time: event_start_time(program_entry: program_entry),
          genre_list: genres,
          style_list: event_styles(genres: genres),
          location_list: location
        )
      rescue StandardError => e
        debugger
        Rails.logger.error(e)
      end
    end

    def page
      @page ||= begin
                  html_content = URI.open(self.class.url).read
                  program_page = Nokolexbor::HTML(html_content)
                end
    end

    # skip iteration by returning false when necessary
    def preprocess(program_entry:)
      true
    end

    def location
      self.class.location
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

    def event_start_time(program_entry:)
      nil
    end

    def event_url(program_entry:)
      raise 'implement in subclass'
    end

    def event_genres(program_entry:)
      []
    end

    def event_styles(genres:)
      Style.tagged_with(genres, any: true).pluck(:name)
    end
  end
end
