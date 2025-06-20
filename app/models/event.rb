class Event < ApplicationRecord
  acts_as_taggable_on :locations, :genres, :styles

  def self.ransackable_attributes(auth_object = nil)
    ['name', 'start_date']
  end

  def self.ransackable_associations(auth_object = nil)
    ['location', 'taggings', 'genres', 'locations', 'styles']
  end

  def to_s
    name
  end
end
