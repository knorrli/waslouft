class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: %i[ destroy ]

  # GET /events
  def index
    @genres = params[:g]&.first&.split(',') || []
    @locations = params[:l]&.first&.split(',') || []

    ransack_query = { m: :or }
    ransack_query[:genres_name_in] = @genres if @genres.present?
    ransack_query[:locations_name_in] = @locations if @locations.present?
    ransack_query[:start_date_between] = params[:d].presence if /\d{4}-\d{2}-\d{2}\s-\s\d{4}-\d{2}-\d{2}/.match?(params[:d].presence)

    @q = Event.ransack(ransack_query)
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

    # Only allow a list of trusted parameters through.
    def event_params
      params.expect(event: [ :name, :start_date ])
    end
end
