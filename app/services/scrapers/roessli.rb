module Scrapers
  class Roessli < Agent
    def self.location
      'Rössli'
    end

    def self.locations
      [location, 'Reitschule', 'Bern', 'BE']
    end

    def self.url
      URI.parse('https://www.souslepont-roessli.ch/')
    end

    def process_events
      get(self.class.url)

      page.css('.rossli-events .event').each do |event_container|
        url = URI.parse(event_container.at_css('a').attr('href').to_s).to_s

        Rails.logger.info "Processing event URL #{url}"

        event = Event.find_or_initialize_by(url: url)
        event.start_time = event_start_time(event_container: event_container)
        event.start_date = event.start_time.to_date
        event.title = event_title(event_container: event_container)
        event.genre_list = event_genres(event_container: event_container)
        event.style_list = event_styles(genres: event.genre_list)
        event.location_list = self.class.locations
        event.save!
      rescue StandardError => e
        raise ScrapeError.new e.message, event
      end
    end

    def event_start_time(event_container:)
      event_date_string = event_container.css('.event-date').attr('datetime').to_s
      /(?<date_string>\d{1,2}\.\s*\w{3}\s\d{4})/ =~ event_date_string
      /(?<day>\d{1,2})\.\s*(?<month>\w{3})\s*(?<year>\d{4})/ =~ date_string
      /(?<time_string>\d{1,2}:\d{1,2})/ =~ event_date_string

      Time.zone.parse("#{year}-#{month_number(month: month)}-#{day}, #{time_string}")
    end

    def event_title(event_container:)
      event_container.css('h2').text.squish
    end

    def event_genres(event_container:)
      event_container.css('.event-categories li').map { |category| category.text.squish }
    end
  end
end
