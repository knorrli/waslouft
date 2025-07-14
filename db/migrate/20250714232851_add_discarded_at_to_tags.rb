class AddDiscardedAtToTags < ActiveRecord::Migration[8.0]
  def change
    add_column :tags, :discarded_at, :datetime
    add_index :tags, :discarded_at
  end
end
