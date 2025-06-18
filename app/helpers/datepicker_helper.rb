module DatepickerHelper
  def datepicker_preset
    {
      today: { label: I18n.t('datepicker.today'), values: [Date.current.iso8601, Date.current.iso8601] },
      tomorrow: { label: I18n.t('datepicker.tomorrow'), values: [Date.current.tomorrow.iso8601, Date.current.tomorrow.iso8601] },
      this_week: { label: I18n.t('datepicker.this_week'), values: [Date.current.beginning_of_week.iso8601, Date.current.end_of_week.iso8601] },
      this_weekend: { label: I18n.t('datepicker.this_weekend'), values: [Date.current.next_occurring(:saturday).iso8601, Date.current.end_of_week.iso8601] },
      next_week: { label: I18n.t('datepicker.next_week'), values: [Date.current.next_week(:monday).iso8601, Date.current.next_week(:sunday).iso8601] },
      next_weekend: { label: I18n.t('datepicker.next_weekend'), values: [Date.current.next_week(:saturday).iso8601, Date.current.next_week(:sunday).iso8601] },
      this_month: { label: I18n.t('datepicker.this_month'), values: [Date.current.beginning_of_month.iso8601, Date.current.end_of_month.iso8601] },
      next_month: { label: I18n.t('datepicker.next_month'), values: [Date.current.beginning_of_month.next_month.iso8601, Date.current.end_of_month.next_month.iso8601] }
    }.with_indifferent_access
  end

  def datepicker_tag(date_range_string)
    button_tag(type: :button, class: 'tag active', data: { action: 'click->datepicker#removeRange', datepicker_range_param: date_range_string }) do
      content_tag(:div, class: 'flex align-baseline gap-small') do
        concat content_tag(:span, nil, class: tag_icon_class(context: 'date'))
        concat datepicker_tag_content(date_range_string)
      end
    end
  end

  def datepicker_tag_content(date_range)
    # start_date, end_date = date_range_string.split(' - ').map { |date_string| Time.zone.parse(date_string).to_date.iso8601 }
    if preset = datepicker_preset[date_range]
      content_tag(:span, preset[:label])
    else
      start_date, end_date = date_range.split(' - ').map { |date_string| Time.zone.parse(date_string).to_date.iso8601 }
      if start_date == end_date
        content_tag(:span, l(start_date.to_date, format: :default))
      else
        content_tag(:span, "#{l(start_date.to_date, format: :default)} - #{l(end_date.to_date, format: :default)}")
      end
    end
  end
end
