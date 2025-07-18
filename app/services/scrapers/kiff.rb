require 'mechanize'

module Scrapers
  class Kiff < Mechanize
    def self.location
      'KIFF'
    end

    def self.locations
      [location, 'Aarau', 'AG']
    end

    def self.url
      'https://www.kiff.ch/programm'
    end

    def self.call
      new.call
    rescue StandardError => e
      debugger
    end

    def initialize
      super
      robots = true
    end

    def call
      get(self.class.url)

      page.css('.FilterPage__FilterResults > .Card-Event').each do |event_container|
        link = Page::Link.new(event_container.at_css('.Card__Link'), @mech, page)
        event = Event.find_or_initialize_by(
          url: URI.parse(link.href).to_s
        )

        event.start_time = Time.zone.parse(event_container.css('.Card__Date time').attr('datetime'))
        event.start_date = event.start_time.to_date
        transact do
          event_page = click(link)
          event.title = event_title(event_page: event_page)
          event.subtitle = event_subtitle(event_page: event_page)
          event.genre_list = event_genres(event_page: event_page)
          event.style_list = event_styles(genres: event.genre_list)
          event.location_list = self.class.locations
        end

        event.save!
      end
    end

    def event_title(event_page:)
      elements = event_page.css('.EventPage__Subtitle h2').children.map do |node|
        next ',' if node.name == 'br'
        next "(#{node.text.squish})" if node['class'] == 'Act__coutry-code' && node.text.squish.present?

        node.text.squish
      end.compact_blank.join(' ')
    end

    def event_subtitle(event_page:)
      event_page.css('.EventPage__SupportActs').children.map do |node|
        next if node.text.squish.blank?

        act_list = node.css('.Act').map do |act|
          country_code = act.css('.Act__country-code').text.squish
          act_name = StringIO.new
          act_name << act.css('.Act__name').text.squish
          act_name << " (#{country_code})" if country_code.present?
          act_name.string.presence || act.text
        end.compact_blank.join(', ')

        "#{node.css('dt').text.squish}: #{act_list}".presence || node.text
      end.compact_blank.join("\n")
    end

    def event_genres(event_page:)
      event_page.css('.EventPage__Tags').children.map { |node| node.text.squish }.compact_blank
    end

    def event_styles(genres:)
      Style.tagged_with(genres, any: true).pluck(:name)
    end

    # def program_entries
    #   page.css('.Card-Event')
    # end

    # def event_title(program_entry:)
    #   program_entry.css('.Card__Title').children.select { |c| !c.matches?('.Act__country-code') }.map(&:content).join
    # end

    # def event_subtitle(program_entry:)
    #   program_entry.css('.Card__Byline').content.squish
    # end

    # def event_start_date(program_entry:)
    #   event_start_time(program_entry: program_entry)
    # end

    # def event_start_time(program_entry:)
    #   date_string = program_entry.css('.Card__Date time').attr('datetime')
    #   Time.zone.parse(date_string)
    # end

    # def event_url(program_entry:)
    #   "https://www.mahogany.ch#{program_entry.css('.views-field-title .field-content a').attr('href').to_s.squish}"
    # end

    # def event_genres(program_entry:)
    #   nil
    # end
  end
end
