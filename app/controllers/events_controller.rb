class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: %i[ destroy ]

  # GET /events
  def index
    @locations = params[:l]&.first&.split(',') || []
    @styles = params[:s]&.first&.split(',') || []
    @genres = params[:g]&.first&.split(',') || []
    @date_ranges = params[:d]&.first&.split(',') || []

    ransack_query = {}
    ransack_query = { m: :or }
    ransack_query[:title_or_subtitle_cont] = params[:q] if params[:q].present?
    ransack_query[:locations_name_in] = @locations if @locations.present?
    ransack_query[:styles_name_in] = @styles if @styles.present?
    ransack_query[:genres_name_in] = @genres if @genres.present?
    if date_ranges = extract_date_ranges(@date_ranges).presence
      ransack_query[:start_date_between_any] = date_ranges
    else
      ransack_query[:start_date_gteq] = Date.today.beginning_of_day
    end

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

  def extract_date_ranges(date_queries)
    date_queries.map do |date_query|
      if preset = helpers.datepicker_preset[date_query]
        start_date, end_date = preset[:values]
        "#{start_date.to_date.iso8601} - #{end_date.to_date.iso8601}"
      else
        /\d{4}-\d{2}-\d{2}\s-\s\d{4}-\d{2}-\d{2}/.match?(date_query) ? date_query : nil
      end
    end
  end
end
