class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag
      .where.not(name: params[:applied])
      .ransack(name_cont: params[:q])
      .result
      .joins(:taggings)
      .select(:name, :context).distinct
  end
end
