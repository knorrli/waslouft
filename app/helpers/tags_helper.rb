module TagsHelper
  def tag_icon_class(context:)
    case context
    when 'tags'
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
