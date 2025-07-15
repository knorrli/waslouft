class Filter < ApplicationRecord
  acts_as_taggable_on :locations, :styles, :genres

  validates :name, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(auth_object = nil)
    ['taggings', 'locations', 'styles', 'genres']
  end

  def to_s
    name
  end

  def to_combobox_display
    name
  end

  def events
    Event.ransack(ransack_query).result(distinct: true).order(start_date: :asc)
  end

  def to_params
    params = { f: id }
    params[:q] = queries.presence
    params[:l] = location_list.presence
    params[:s] = style_list.presence
    params[:g] = genre_list.presence
    params[:d] = date_ranges.presence
    params
  end

  def ransack_query
    ransack_query = {
      g: [
        {
          title_or_subtitle_or_styles_name_or_genres_name_cont_any: queries,
          styles_name_in: style_list.presence,
          genres_name_in: genre_list.presence,
          m: Ransack::Constants::OR
        },
        {
          locations_name_in: location_list.presence
        },
        {}.tap do |date_group|
          if mapped_ranges = map_date_ranges(date_ranges).presence
            date_group[:start_date_between_any] = mapped_ranges
          else
            date_group[:start_date_gteq] = Date.current.beginning_of_day
          end
        end
      ]
    }

    ransack_query
  end


  def queries=(new_queries)
    super(ActsAsTaggableOn.default_parser.new(new_queries).parse)
  end

  def date_ranges=(new_date_ranges)
    super(ActsAsTaggableOn.default_parser.new(new_date_ranges).parse)
  end

  private

  def map_date_ranges(date_ranges)
    return [] if date_ranges.blank?

    date_ranges.map do |range|
      if preset = Datepicker.preset[range]
        start_date, end_date = preset[:values]
        "#{start_date.to_date.iso8601} - #{end_date.to_date.iso8601}"
      else
        /\d{4}-\d{2}-\d{2}\s-\s\d{4}-\d{2}-\d{2}/.match?(range) ? range : nil
      end
    end
  end
end
