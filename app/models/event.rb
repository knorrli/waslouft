class Event < ApplicationRecord
  acts_as_taggable_on :tags

  belongs_to :location

  def to_s
    name
  end
end
