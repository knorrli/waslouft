class AddUniqueIndexForLowercaseTags < ActiveRecord::Migration[8.0]
  def change
    # CREATE UNIQUE INDEX index_tags_on_lower_name on tags (lower(name));
    add_index :tags, 'lower(name)', unique: true, name: 'index_tags_on_lower_name'
  end
end
