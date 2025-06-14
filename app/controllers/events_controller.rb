class EventsController < ApplicationController
  before_action :set_event, only: %i[ show edit update destroy ]

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

  # GET /events/1
  def show
  end

  # GET /events/new
  def new
    @event = Event.new
  end

  # GET /events/1/edit
  def edit
  end

  # POST /events
  def create
    @event = Event.new(event_params)

    if @event.save
      redirect_to @event, notice: "Event was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /events/1
  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Event was successfully updated.", status: :see_other
    else
      render :edit, status: :unprocessable_entity
    end
  end

  # DELETE /events/1
  def destroy
    @event.destroy!
    redirect_to events_path, notice: "Event was successfully destroyed.", status: :see_other
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
