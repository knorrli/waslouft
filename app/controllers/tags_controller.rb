class TagsController < ApplicationController
  allow_unauthenticated_access

  def index
    @tags = ActsAsTaggableOn::Tag
      .where.not(name: params[:applied])
      .ransack(name_cont: params[:q])
      .result
      .joins(:taggings)
      .where(taggings: { context: params[:context].presence, taggable_type: Event.name })
      .order(name: :asc)
      .select(:name, :context).distinct
  end

  def chips
    @tags = ActsAsTaggableOn::Tag
      .where(name: params[:combobox_values].split(','))
      .joins(:taggings)
      .where(taggings: { context: params[:context].presence, taggable_type: Event.name })
      .distinct
      .order(name: :asc)
  end

  def destroy
    @tag = ActsAsTaggableOn::Tag.find(params[:id])
    @tag.discard

    redirect_back fallback_location: admin_path
  end
end
