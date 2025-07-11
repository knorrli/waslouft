class CreateFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :filters do |t|
      t.string :name
      t.string :query
      t.jsonb :date_ranges, default: []

      t.timestamps
    end
    add_index :filters, :name, unique: true
  end
end
