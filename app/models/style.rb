class Style < ApplicationRecord
  acts_as_taggable_on :genres

  def to_s
    name
  end

  def to_combobox_display
    name
  end
end
