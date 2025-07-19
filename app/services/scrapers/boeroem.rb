module Scrapers
  class Boeroem < Agent
    def self.location
      'Böröm'
    end

    def self.locations
      [location, 'Aarau', 'AG']
    end

    def self.url
      URI.parse('https://boeroem.ch/')
    end

    def process_events
      get(self.class.url)

      page.css('.ast-article-single .veranstaltung').each do |event_container|
        link = Page::Link.new(event_container.at_css('.elementor-heading-title a'), @mech, page)
        url = URI.parse(link.href).to_s

        Rails.logger.info "Processing event URL #{url}"

        event = Event.find_or_initialize_by(url: url)
        puts "(#{event.id}): #{event.url}"
        transact do
          event_page = click(link)
          event.start_time = event_start_time(event_page: event_page)
          event.start_date = event.start_time.to_date
          event.title = event_title(event_page: event_page)
          event.subtitle = event_subtitle(event_page: event_page)
          event.genre_list = event_genres(event_page: event_page)
          event.style_list = event_styles(genres: event.genre_list)
          event.location_list = self.class.locations
          event.save!
        rescue StandardError => e
          raise ScrapeError.new e.message, event
        end
      end
    end

    def event_start_time(event_page:)
      date_string = event_page.at_css('.event-single-datum').text.squish
      /(?<day>\d{1,2})\.\W*(?<month>\S*)\W*(?<year>\d{4})*/ =~ date_string

      time_string = event_page.css('.elementor-widget-container').select { |node| node.text.squish.starts_with?('Show Start') }.map(&:text).join[/\d{2}:\d{2}/]

      Time.zone.parse("#{year}-#{month_number(month: month)}-#{day}, #{time_string}")
    end

    def event_title(event_page:)
      event_page.at_css('.elementor-top-section .elementor-widget-theme-post-title').text.squish
    end

    def event_subtitle(event_page:)
      support = event_page.css('.elementor-top-section .event-single-untertitel').text.squish
    end

    def event_genres(event_page:)
      event_page.css('.event__status').map { |node| node.text.squish }.compact_blank
      nil
    end
  end
end
