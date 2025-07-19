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
      Rails.logger.info "Updating style #{style} with genre #{genre_style_assignment_params[:tag_value]}..."
      style.genre_list.add(genre_style_assignment_params[:tag_value])
      Rails.logger.info "Addded tag to style"
      style.save
      Rails.logger.info 'Done!'
    end
    Rails.logger.info 'After updating styles'

    Rails.logger.info 'Before updating events'
    Event.tagged_with(genre_style_assignment_params[:tag_value], on: :genres).find_each do |tagged_event|
      tagged_event.style_list.add(styles.map(&:name), parse: true)
      tagged_event.save
    end
    Rails.logger.info 'After updating events'


    Rails.logger.info 'Before redirect'
    redirect_to genre_style_assignments_path(page: params[:page])
  end

  private

  def genre_style_assignment_params
    params.expect(genre_style_assignment: [:style_ids, :style_id, :tag_value])
  end
end
