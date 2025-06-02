class Location < ApplicationRecord
  has_many :events, dependent: :destroy

  def to_s
    name
  end
end
