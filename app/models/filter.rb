class Filter < ApplicationRecord
  acts_as_taggable_on :locations, :styles, :genres

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
    to_s
  end

  def to_ransack_query
    ransack_query = {}
    ransack_query = { m: :or }
    ransack_query[:title_or_subtitle_cont] = query
    ransack_query[:locations_name_in] = location_list.presence
    ransack_query[:styles_name_in] = style_list.presence
    ransack_query[:genres_name_in] = genre_list.presence
    if mapped_ranges = map_date_ranges(date_ranges).presence
      ransack_query[:start_date_between_any] = mapped_ranges
    else
      ransack_query[:start_date_gteq] = Date.current.beginning_of_day
    end

    ransack_query
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
