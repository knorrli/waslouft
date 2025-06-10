class Event < ApplicationRecord
  acts_as_taggable_on :locations, :genres

  belongs_to :location

  def self.ransackable_attributes(auth_object = nil)
    []
  end

  def self.ransackable_associations(auth_object = nil)
    ['location', 'taggings', 'genres', 'locations']
  end

  def to_s
    name
  end
end
