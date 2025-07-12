class EventTagStatsPresenter
  def location_tags
    ActsAsTaggableOn::Tag
      .includes(:taggings)
      .where(taggings: { context: 'locations', taggable_type: Event.name })
  end

  def style_tags
    ActsAsTaggableOn::Tag
      .includes(:taggings)
      .where(taggings: { context: 'styles', taggable_type: Event.name })
  end

  def genre_tags
    ActsAsTaggableOn::Tag
      .includes(:taggings)
      .where(taggings: { context: 'genres', taggable_type: Event.name })
  end

  def assigned_genre_tags
    genre_tags.where(
      'EXISTS (:taggings_for_genre_and_style)',
      taggings_for_genre_and_style: subquery_genre_tags_associated_to_style
    )
  end

  def unassigned_genre_tags
    genre_tags.where(
      'NOT EXISTS (:taggings_for_genre_and_style)',
      taggings_for_genre_and_style: subquery_genre_tags_associated_to_style
    )
  end

  private

  def subquery_genre_tags_associated_to_style
    ActsAsTaggableOn::Tagging
      .where(context: 'genres', taggable_type: Style.name)
      .where('taggings.tag_id = tags.id')
  end
end
