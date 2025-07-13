class GenreStyleAssignmentsController < ApplicationController
  def index
    @event_tag_stats = EventTagStatsPresenter.new
    @unassigned_genre_tags = EventTagStatsPresenter.new.unassigned_genre_tags.order(name: :asc).page(params[:page])
  end

  def create
    @style = Style.find(genre_style_assignment_params[:style_id])
    @style.genre_list.add(genre_style_assignment_params[:tag_value])
    @style.save
    redirect_to genre_style_assignments_path
  end

  private

  def genre_style_assignment_params
    params.expect(genre_style_assignment: [:style_id, :tag_value])
  end
end
