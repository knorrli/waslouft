module DatepickerHelper
  def datepicker_preset
    {
      today: { label: I18n.t('datepicker.today'), values: [Date.current.to_time.to_i*1000, Date.current.to_time.to_i*1000] },
      tomorrow: { label: I18n.t('datepicker.tomorrow'), values: [Date.current.tomorrow.to_time.to_i*1000, Date.current.tomorrow.to_time.to_i*1000] },
      this_week: { label: I18n.t('datepicker.this_week'), values: [Date.current.beginning_of_week.to_time.to_i*1000, Date.current.end_of_week.to_time.to_i*1000] },
      this_weekend: { label: I18n.t('datepicker.this_weekend'), values: [Date.current.next_occurring(:saturday).to_time.to_i*1000, Date.current.end_of_week.to_time.to_i*1000] },
      next_week: { label: I18n.t('datepicker.next_week'), values: [Date.current.next_week(:monday).to_time.to_i*1000, Date.current.next_week(:sunday).to_time.to_i*1000] },
      next_weekend: { label: I18n.t('datepicker.next_weekend'), values: [Date.current.next_week(:saturday).to_time.to_i*1000, Date.current.next_week(:sunday).to_time.to_i*1000] },
      this_month: { label: I18n.t('datepicker.this_month'), values: [Date.current.beginning_of_month.to_time.to_i*1000, Date.current.end_of_month.to_time.to_i*1000] },
      next_month: { label: I18n.t('datepicker.next_month'), values: [Date.current.beginning_of_month.next_month.to_time.to_i*1000, Date.current.end_of_month.next_month.to_time.to_i*1000] }
    }.with_indifferent_access
  end

  def datepicker_tag(date_range_string)
    button_tag(type: :button, class: 'tag active', data: { action: 'click->datepicker#clear' }) do
      content_tag(:div, class: 'flex align-baseline gap-small') do
        concat content_tag(:span, nil, class: tag_icon_class(context: 'date'))
        concat datepicker_tag_content(date_range_string)
      end
    end
  end

  def datepicker_tag_content(date_range_string)
    start_date, end_date = date_range_string.split(' - ').map { |date_string| Time.zone.parse(date_string) }
    if preset_values = datepicker_preset.values.find { |attributes| attributes[:values] == [start_date.to_i*1000, end_date.to_i*1000] }
      content_tag(:span, preset_values[:label])
    else
      if start_date == end_date
        content_tag(:span, l(start_date.to_date, format: :default))
      else
        content_tag(:span, "#{l(start_date.to_date, format: :default)} - #{l(end_date.to_date, format: :default)}")
      end
    end
  end
end
