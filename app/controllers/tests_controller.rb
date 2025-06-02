class TestsController < ApplicationController
  layout false

  def show
    render params[:name]
  end
end
