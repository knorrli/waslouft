class FiltersController < ApplicationController
  allow_unauthenticated_access

  def index
    @filters = Filter.ransack(name_cont: params[:q]).result
  end

  def upsert
    @filter = Filter.find_or_initialize_by(name: params.expect(:n))

    if @filter.update(
        query: params.fetch(:q),
        location_list: params.expect(l: []).split(','),
        style_list: params.expect(s: []).split(','),
        genre_list: params.expect(g: []).split(','),
        date_ranges: params.expect(d: [])&.first&.split(',')
    )
      redirect_to events_path(f: @filter.id)
    else
      redirect_to events_path
    end
  end

  def filter_params
    params.permit(:name, :q, :l, :s, :g, :d)
  end
end
