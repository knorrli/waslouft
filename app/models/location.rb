class Location < ApplicationRecord
  has_many :events, dependent: :destroy

  def self.ransackable_attributes(auth_object = nil)
    ['name']
  end

  def to_s
    name
  end

end
