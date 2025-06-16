class TagsController < ApplicationController
  allow_unauthenticated_access

  def index
    tag_groups = TagGroup
      .where.not(name: params[:applied])
      .ransack(name_cont: params[:q])
      .result

    acts_as_taggable_on_tags = ActsAsTaggableOn::Tag
      .where.not(name: params[:applied])
      .ransack(name_cont: params[:q])
      .result
      .joins(:taggings)
      .select(:name, :context).distinct

    @tags = tag_groups | acts_as_taggable_on_tags
  end
end
