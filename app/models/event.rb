class Event < ApplicationRecord
  acts_as_taggable_on :locations, :styles, :genres

  validates :title, :start_date, :url, presence: true

  def self.ransackable_attributes(auth_object = nil)
    ['title', 'subtitle', 'start_date']
  end

  def self.ransackable_associations(auth_object = nil)
    ['taggings', 'locations', 'styles', 'genres']
  end

  def to_s
    [
      start_date.strftime('%y-%m-%d'),
      title.truncate(40),
      subtitle&.truncate(20),
      locations.map(&:name).join(', ')
    ].compact_blank.join(' || ')
  end
end
