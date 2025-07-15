module TagsHelper
  def tag_icon_class(context:)
    case context.to_s
    when 'query'
      'ti-search'
    when 'date'
      'ti-calendar'
    when 'styles'
      'ti-music-alt'
    when 'genres'
      'ti-tag'
    when 'locations'
      'ti-home'
    else
      'ti-bolt'
    end
  end
end
