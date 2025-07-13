module DatepickerHelper
  def datepicker_tag(date_range_string)
    button_tag(type: :button, class: 'tag active', data: { action: 'click->datepicker#removeRange', datepicker_range_param: date_range_string }) do
      content_tag(:div, class: 'flex align-baseline gap-small') do
        concat content_tag(:span, nil, class: tag_icon_class(context: 'date'))
        concat datepicker_tag_content(date_range_string)
      end
    end
  end

  def datepicker_tag_content(date_range)
    if preset = Datepicker.preset[date_range]
      content_tag(:span, preset[:label])
    else
      debugger
      start_date, end_date = date_range.split(' - ').map { |date_string| Time.zone.parse(date_string).to_date.iso8601 }
      if start_date == end_date
        content_tag(:span, l(start_date.to_date, format: :default))
      else
        content_tag(:span, "#{l(start_date.to_date, format: :default)} - #{l(end_date.to_date, format: :default)}")
      end
    end
  end
end
