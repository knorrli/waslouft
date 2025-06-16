class TagGroup < ApplicationRecord
  acts_as_taggable_on :genres

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def self.ransackable_associations(auth_object = nil)
    ['taggings', 'genres']
  end

  def to_s
    name
  end

  def to_combobox_display
    name
  end

  # simulate ActsAsTaggableOn::Tag
  def context
    :groups
  end
end
