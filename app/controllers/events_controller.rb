class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: %i[ destroy ]

  # GET /events
  def index
    @filter = Filter.find_by(id: params[:f]) || Filter.find_or_initialize_by(name: params[:n])
    @filter.query = params[:q] if params[:q].present?
    @filter.location_list = params[:l] if params[:l].present?
    @filter.style_list = params[:s] if params[:s].present?
    @filter.genre_list = params[:g] if params[:g].present?
    @filter.date_ranges = params[:d]&.first&.split(',') if params[:d].present?

    # @filter ||= Filter.new(
    #   name: params[:filter],
    #   query: params[:q],
    #   location_list: params[:l]&.first&.split(','),
    #   style_list: params[:s]&.first&.split(','),
    #   genre_list: params[:g]&.first&.split(','),
    #   date_ranges: params[:d]&.first&.split(',') || []
    # )

    @q = Event.ransack(@filter.to_ransack_query)
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
