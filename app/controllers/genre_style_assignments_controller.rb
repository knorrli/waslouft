class GenreStyleAssignmentsController < ApplicationController
  def index
    Rails.logger.info 'Loading index'
    @event_tag_stats = EventTagStatsPresenter.new
    @unassigned_genre_tags = @event_tag_stats.unassigned_genre_tags.order(name: :asc).page(params[:page]).per(1)
    Rails.logger.info 'After index'
  end

  def create
    styles = Style.where(id: genre_style_assignment_params[:style_ids].split(','))

    styles.each do |style|
      # manually creating taggable instead of #genre_list.add for performance reasons
      ActsAsTaggableOn::Tagging.create(
        taggable: style,
        tag: ActsAsTaggableOn::Tag.find_by(name: genre_style_assignment_params[:tag_value]),
        context: :genres
      )

      Event.tagged_with(genre_style_assignment_params[:tag_value], on: :genres).find_each do |tagged_event|
        tagged_event.style_list.add(style.name)
        tagged_event.save
      end
    end

    redirect_to genre_style_assignments_path(page: params[:page])
  end

  private

  def genre_style_assignment_params
    params.expect(genre_style_assignment: [:style_ids, :style_id, :tag_value])
  end
end
