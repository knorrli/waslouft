class EventsController < ApplicationController
  allow_unauthenticated_access

  before_action :set_event, only: %i[ destroy ]

  # GET /events
  def index
    @tag_groups = params[:tg]&.first&.split(',')&.map { |name| TagGroup.find_by(name: name) }&.compact || []
    @genres = params[:g]&.first&.split(',') || []
    @locations = params[:l]&.first&.split(',') || []
    @date_ranges = params[:d]&.first&.split(',') || []

    ransack_query = {}
    ransack_query = { m: :or }
    ransack_query[:genres_name_in] = @genres | ActsAsTaggableOn::Tagging.includes(:tag).where(taggable: @tag_groups).pluck(:name) if @genres.present? || @tag_groups.present?
    ransack_query[:locations_name_in] = @locations if @locations.present?
    ransack_query[:start_date_between_any] = extract_date_ranges(@date_ranges)

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
