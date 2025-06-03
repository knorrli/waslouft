class Event < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :location

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    ['location', 'taggings', 'tags']
  end

  def to_s
    name
  end
end
