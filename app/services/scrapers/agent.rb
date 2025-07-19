require 'rubygems'
require 'mechanize'

module Scrapers
  class Agent < Mechanize
    # include Registerable

    class ScrapeError < StandardError
      attr_reader :event

      def initialize(message, event)
        @event = event
        super("#{message}, Event: #{event.attributes}")
      end
    end

    def self.call
      new.call
    end

    def initialize
      super
      robots = true
    end

    def call
      Rails.logger.info "Start processing #{self.class.location} at #{self.class.url}"

      process_events

      Rails.logger.info "Finished processing #{self.class.location}"
    end

    private

    def event_styles(genres:)
      Style.tagged_with(genres, any: true).pluck(:name)
    end

    def month_number(month:)
      month_numbers[month].presence || month
    end

    def month_numbers
      @month_numbers ||= {
        'Januar' => 1,
        'Februar' => 2,
        'Mär' => 3,
        'März' => 3,
        'Mai' => 5,
        'Juni' => 6,
        'Juli' => 7,
        'Okt' => 10,
        'Oktober' => 10,
        'Dez' => 12,
        'Dezember' => 12
      }
    end
  end
end
