class GenreStyleAssignmentsController < ApplicationController
  def index
    @event_tag_stats = EventTagStatsPresenter.new
    @unassigned_genre_tags = @event_tag_stats.unassigned_genre_tags.order(name: :asc).page(params[:page]).per(1)
  end

  def create
    styles = Style.where(id: genre_style_assignment_params[:style_ids].split(','))
    styles.each do |style|
      style.genre_list.add(genre_style_assignment_params[:tag_value])
      style.save
      Event.tagged_with(genre_style_assignment_params[:tag_value], on: :genres).each do |tagged_event|
        tagged_event.style_list.add(style)
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
