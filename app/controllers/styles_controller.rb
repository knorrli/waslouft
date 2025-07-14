class StylesController < ApplicationController
  def chips
    @styles = Style
      .where(id: params[:combobox_values].split(','))
      .distinct
      .order(name: :asc)

    render turbo_stream: helpers.combobox_selection_chips_for(@styles)
  end
end
