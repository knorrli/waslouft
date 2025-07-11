class TagsController < ApplicationController
  allow_unauthenticated_access

  def index
    @tags = ActsAsTaggableOn::Tag
      .where.not(name: params[:applied])
      .ransack(name_cont: params[:q])
      .result
      .joins(:taggings)
      .where(taggings: { context: params[:context].presence, taggable_type: Event.name })
      .select(:name, :context).distinct.order(name: :asc)
  end
end
