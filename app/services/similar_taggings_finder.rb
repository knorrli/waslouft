class SimilarTaggingsFinder
  include ActiveRecord::ConnectionAdapters::Quoting

  attr_reader :context, :taggable_type, :tag

  def self.call(context:, taggable_type:, tag:)
    new(context: context, taggable_type: taggable_type, tag: tag).call
  end

  def initialize(context:, taggable_type:, tag:)
    @context = context
    @taggable_type = taggable_type
    @tag = tag
  end

  def call
    ActsAsTaggableOn::Tagging
      .joins(:tag)
      .where(context: context, taggable_type: taggable_type)
      .select("*, levenshtein(tags.name, #{quote(tag)}) as distance")
      .order('distance ASC')
  end
end
