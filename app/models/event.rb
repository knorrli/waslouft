class Event < ApplicationRecord
  acts_as_taggable_on :locations, :styles, :genres

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'subtitle', 'start_date']
  end

  def self.ransackable_associations(auth_object = nil)
    ['taggings', 'locations', 'styles', 'genres']
  end

  def to_s
    title
  end
end
