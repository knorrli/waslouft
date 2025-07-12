class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: %i[ destroy ]

  # GET /events
  def index
    @filter = Filter.find_or_initialize_by(id: params[:f])
    @filter.location_list = params[:l].split(',') if params[:l]
    @filter.style_list = params[:s].split(',') if params[:s]
    @filter.genre_list = params[:g].split(',') if params[:g]
    @filter.date_ranges = params[:d].split(',') if params[:d]

    @q = Event.ransack(@filter.ransack_query)
    @events = @q.result(distinct: true).order(start_date: :asc).page(params[:page])
  end

  # DELETE /events/1
  def destroy
    @event.destroy!
    redirect_to events_path, status: :see_other
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_event
    @event = Event.find(params.expect(:id))
  end
end
