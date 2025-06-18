module TagsHelper
  def tag_icon_class(context:)
    case context.to_s
    when 'date'
      'ti-calendar'
    when 'groups'
      'ti-music-alt'
    when 'genres'
      'ti-music'
    when 'locations'
      'ti-home'
    else
      'ti-bolt'
    end
  end
end
