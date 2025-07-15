class CreateFilters < ActiveRecord::Migration[8.0]
  def change
    create_table :filters do |t|
      t.string :name
      t.jsonb :queries, default: []
      t.jsonb :date_ranges, default: []

      t.timestamps
    end
  end
end
